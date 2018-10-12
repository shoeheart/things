# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_07_25_105802) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Required by logidze
  enable_extension :hstore

  # Prevent deletion from any data tables.  Only is_deleted = true
  # can be used on any table that adds this trigger
  # from http://joshualat.com/posts/postgresql-triggers-in-action/
  execute <<-SQL
    create or replace function prevent_deletion()
      returns trigger as
    $body$
      begin
        raise exception 'deletion not allowed for table %', tg_argv[0];
        return null;
      end;
    $body$ language plpgsql;
  SQL

  # add in logidze functions to maintain log_data field on each row
  # via triggers

  execute <<-SQL
    CREATE OR REPLACE FUNCTION logidze_version(v bigint, data jsonb, ts timestamp with time zone, blacklist text[] DEFAULT '{}') RETURNS jsonb AS $body$
      DECLARE
        buf jsonb;
      BEGIN
        buf := jsonb_build_object(
                 'ts',
                 (extract(epoch from ts) * 1000)::bigint,
                 'v',
                  v,
                  'c',
                  logidze_exclude_keys(data, VARIADIC array_append(blacklist, 'log_data'))
                 );
        IF current_setting('logidze.meta',true) is null or
           current_setting('logidze.meta',true) = '' THEN
          raise exception
            'Cannot update database with null logidze.meta';
        END IF;
        IF coalesce(current_setting('logidze.meta'), '') <> '' THEN
          buf := jsonb_set(buf, ARRAY['m'], current_setting('logidze.meta')::jsonb);
        END IF;
        RETURN buf;
      END;
    $body$
    LANGUAGE plpgsql;

    CREATE OR REPLACE FUNCTION logidze_snapshot(item jsonb, ts_column text, blacklist text[] DEFAULT '{}') RETURNS jsonb AS $body$
      DECLARE
        ts timestamp with time zone;
      BEGIN
        IF ts_column IS NULL THEN
          ts := statement_timestamp();
        ELSE
          ts := coalesce((item->>ts_column)::timestamp with time zone, statement_timestamp());
        END IF;
        return json_build_object(
          'v', 1,
          'h', jsonb_build_array(
                 logidze_version(1, item, ts, blacklist)
               )
          );
      END;
    $body$
    LANGUAGE plpgsql;

    CREATE OR REPLACE FUNCTION logidze_exclude_keys(obj jsonb, VARIADIC keys text[]) RETURNS jsonb AS $body$
      DECLARE
        res jsonb;
        key text;
      BEGIN
        res := obj;
        FOREACH key IN ARRAY keys
        LOOP
          res := res - key;
        END LOOP;
        RETURN res;
      END;
    $body$
    LANGUAGE plpgsql;

    CREATE OR REPLACE FUNCTION logidze_compact_history(log_data jsonb) RETURNS jsonb AS $body$
      DECLARE
        merged jsonb;
      BEGIN
        merged := jsonb_build_object(
          'ts',
          log_data#>'{h,1,ts}',
          'v',
          log_data#>'{h,1,v}',
          'c',
          (log_data#>'{h,0,c}') || (log_data#>'{h,1,c}')
        );

        IF (log_data#>'{h,1}' ? 'm') THEN
          merged := jsonb_set(merged, ARRAY['m'], log_data#>'{h,1,m}');
        END IF;

        return jsonb_set(
          log_data,
          '{h}',
          jsonb_set(
            log_data->'h',
            '{1}',
            merged
          ) - 0
        );
      END;
    $body$
    LANGUAGE plpgsql;

    CREATE OR REPLACE FUNCTION logidze_logger() RETURNS TRIGGER AS $body$
      DECLARE
        changes jsonb;
        version jsonb;
        snapshot jsonb;
        new_v integer;
        size integer;
        history_limit integer;
        debounce_time integer;
        current_version integer;
        merged jsonb;
        iterator integer;
        item record;
        columns_blacklist text[];
        ts timestamp with time zone;
        ts_column text;
      BEGIN
        ts_column := NULLIF(TG_ARGV[1], 'null');
        columns_blacklist := COALESCE(NULLIF(TG_ARGV[2], 'null'), '{}');

        IF TG_OP = 'INSERT' THEN
          snapshot = logidze_snapshot(to_jsonb(NEW.*), ts_column, columns_blacklist);

          IF snapshot#>>'{h, -1, c}' != '{}' THEN
            NEW.log_data := snapshot;
          END IF;

        ELSIF TG_OP = 'UPDATE' THEN

          IF OLD.log_data is NULL OR OLD.log_data = '{}'::jsonb THEN
            snapshot = logidze_snapshot(to_jsonb(NEW.*), ts_column, columns_blacklist);
            IF snapshot#>>'{h, -1, c}' != '{}' THEN
              NEW.log_data := snapshot;
            END IF;
            RETURN NEW;
          END IF;

          history_limit := NULLIF(TG_ARGV[0], 'null');
          debounce_time := NULLIF(TG_ARGV[3], 'null');

          current_version := (NEW.log_data->>'v')::int;

          IF ts_column IS NULL THEN
            ts := statement_timestamp();
          ELSE
            ts := (to_jsonb(NEW.*)->>ts_column)::timestamp with time zone;
            IF ts IS NULL OR ts = (to_jsonb(OLD.*)->>ts_column)::timestamp with time zone THEN
              ts := statement_timestamp();
            END IF;
          END IF;

          IF NEW = OLD THEN
            RETURN NEW;
          END IF;

          IF current_version < (NEW.log_data#>>'{h,-1,v}')::int THEN
            iterator := 0;
            FOR item in SELECT * FROM jsonb_array_elements(NEW.log_data->'h')
            LOOP
              IF (item.value->>'v')::int > current_version THEN
                NEW.log_data := jsonb_set(
                  NEW.log_data,
                  '{h}',
                  (NEW.log_data->'h') - iterator
                );
              END IF;
              iterator := iterator + 1;
            END LOOP;
          END IF;

          changes := hstore_to_jsonb_loose(
            hstore(NEW.*) - hstore(OLD.*)
          );

          new_v := (NEW.log_data#>>'{h,-1,v}')::int + 1;

          size := jsonb_array_length(NEW.log_data->'h');
          version := logidze_version(new_v, changes, ts, columns_blacklist);

          IF version->>'c' = '{}' THEN
            RETURN NEW;
          END IF;

          IF (
            debounce_time IS NOT NULL AND
            (version->>'ts')::bigint - (NEW.log_data#>'{h,-1,ts}')::text::bigint <= debounce_time
          ) THEN
            -- merge new version with the previous one
            new_v := (NEW.log_data#>>'{h,-1,v}')::int;
            version := logidze_version(new_v, (NEW.log_data#>'{h,-1,c}')::jsonb || changes, ts, columns_blacklist);
            -- remove the previous version from log
            NEW.log_data := jsonb_set(
              NEW.log_data,
              '{h}',
              (NEW.log_data->'h') - (size - 1)
            );
          END IF;

          NEW.log_data := jsonb_set(
            NEW.log_data,
            ARRAY['h', size::text],
            version,
            true
          );

          NEW.log_data := jsonb_set(
            NEW.log_data,
            '{v}',
            to_jsonb(new_v)
          );

          IF history_limit IS NOT NULL AND history_limit = size THEN
            NEW.log_data := logidze_compact_history(NEW.log_data);
          END IF;
        END IF;

        return NEW;
      END;
      $body$
      LANGUAGE plpgsql;
  SQL

  # call this after table creation
  def log_and_prevent_deletion(table,black_list_columns)
    raise "Invalid blacklist #{black_list_columns}" unless
      black_list_columns.is_a?(Array)

    execute <<-SQL
      create trigger #{table}_prevent_deletion
        before delete on #{table}
        for each row
        execute procedure prevent_deletion(#{table});

      CREATE TRIGGER logidze_on_#{table}
      BEFORE UPDATE OR INSERT ON #{table} FOR EACH ROW
      WHEN (coalesce(current_setting('logidze.disabled',true), '') <> 'on')
      EXECUTE PROCEDURE
        logidze_logger(
          null, -- history_limit (null = infinite)
          'updated_at' -- default timestamp_column unless specified
          #{
            (
              black_list_columns.empty? ?
              '' :
              ",'{" + black_list_columns.join(", ") + "}'"
            )
          }
        );
    SQL
  end

  create_table "species", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "is_deleted", null: false, default: false
    t.jsonb "log_data", null: false
    t.integer "lock_version", null: false, default: 0
    t.index(
      ["name"],
      name: "index_species_on_name",
      unique: true,
      using: :btree
    )
  end
  log_and_prevent_deletion("species",%w(lock_version))

  create_table "toy_types", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "is_deleted", null: false, default: false
    t.jsonb "log_data", null: false
    t.integer "lock_version", null: false, default: 0
    t.index(
      ["name"],
      name: "index_toy_types_on_name",
      unique: true,
      using: :btree
    )
  end
  log_and_prevent_deletion("toy_types",%w(lock_version))

  create_table "animals", force: :cascade do |t|
    t.string "name", null: false
    t.date "birth_date", null: false
    t.boolean "is_vaccinated", null: false
    t.references(
      :species,
      foreign_key: {
        name: "animals_fk_species"
      },
      index: {
        name: "index_animals_on_species_id"
      },
      null: false
    )
    t.boolean "is_deleted", null: false, default: false
    t.jsonb "log_data", null: false
    t.integer "lock_version", null: false, default: 0
  end
  log_and_prevent_deletion("animals",%w(lock_version))

  create_table "toys", force: :cascade do |t|
    t.date "acquired_on", null: false
    t.references(
      :animal,
      foreign_key: {
        name: "toys_fk_animals",
        on_delete: :cascade
      },
      index: {
        name: "index_toys_on_animal_id"
      },
      null: false,
    )
    t.references(
      :toy_type,
      foreign_key: {
        name: "toys_fk_toy_types"
      },
      index: {
        name: "index_toys_on_toy_type_id"
      },
      null: false
    )
    t.boolean "is_deleted", null: false, default: false
    t.jsonb "log_data", null: false
    t.integer "lock_version", null: false, default: 0
  end
  log_and_prevent_deletion("toys",%w(lock_version))

  create_table "people", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.date "birth_date", null: false
    t.boolean "is_deleted", null: false, default: false
    t.jsonb "log_data", null: false
    t.integer "lock_version", null: false, default: 0
  end
  log_and_prevent_deletion("people",%w(lock_version))

  create_table "animal_adoptions", force: :cascade do |t|
    t.date "adopted_on", null: false
    t.references(
      :animal,
      foreign_key: {
        name: "animal_adoptions_fk_animals",
      },
      index: {
        name: "index_animal_adoptions_on_animal_id"
      },
      null: false
    )
    t.references(
      :person,
      foreign_key: {
        name: "animal_adoptions_fk_people",
      },
      index: {
        name: "index_animal_adoptions_on_person_id"
      },
      null: false
    )
    t.boolean "is_deleted", null: false, default: false
    t.jsonb "log_data", null: false
    t.integer "lock_version", null: false, default: 0
    # any animal can only be adopted by one person at a time.
    # don't need ["person_id","animal_id"] unique index since
    # this one takes care of that case as well
    t.index(
      ["animal_id"],
      name: "index_animal_adoptions_animal",
      unique: true,
      where: "is_deleted = false",
      using: :btree
    )
  end
  log_and_prevent_deletion("animal_adoptions",%w(lock_version))

  create_table :delayed_jobs, force: true do |t|
    t.integer :priority, default: 0, null: false # Allows some jobs to jump to the front of the queue
    t.integer :attempts, default: 0, null: false # Provides for retries, but still fail eventually.
    t.text :handler,                 null: false # YAML-encoded string of the object that will do work
    t.text :last_error                           # reason for last failure (See Note below)
    t.datetime :run_at                           # When to run. Could be Time.zone.now for immediately, or sometime in the future.
    t.datetime :locked_at                        # Set when a client is working on this object
    t.datetime :failed_at                        # Set when all retries have failed (actually, by default, the record is deleted instead)
    t.string :locked_by                          # Who is working on this object (if locked)
    t.string :queue                              # The name of the queue this job is in
    t.timestamps null: true
    t.index(
      ["priority", "run_at"],
      name: "index_delayed_jobs_priority_run_at"
    )
    t.index(
      ["queue"],
      name: "index_delayed_jobs_queue"
    )
  end
end
