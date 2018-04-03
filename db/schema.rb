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

ActiveRecord::Schema.define(version: 2018_03_31_201829) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "species", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index(
      ["name"],
      name: "index_species_on_name",
      unique: true,
      using: :btree
    )
    t.integer "lock_version", null: false, default: 0
  end

  create_table "toy_types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index(
      ["name"],
      name: "index_toy_types_on_name",
      unique: true,
      using: :btree
    )
    t.integer "lock_version", null: false, default: 0
  end

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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "lock_version", null: false, default: 0
  end

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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "lock_version", null: false, default: 0
  end

  create_table "people", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.date "birth_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "lock_version", null: false, default: 0
  end

  create_table "pet_ownerships", force: :cascade do |t|
    t.date "adopted_on", null: false
    t.references(
      :animal,
      foreign_key: {
        name: "pet_ownerships_fk_animals",
      },
      index: {
        name: "index_pet_ownerships_on_animal_id"
      },
      null: false
    )
    t.references(
      :person,
      foreign_key: {
        name: "pet_ownerships_fk_people",
      },
      index: {
        name: "index_pet_ownerships_on_person_id"
      },
      null: false
    )
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "lock_version", null: false, default: 0
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index(
      ["blob_id"],
      name: "index_active_storage_attachments_on_blob_id"
    )
    t.index(
      [
        "record_type",
        "record_id",
        "name",
        "blob_id"
      ],
      name: "index_active_storage_attachments_uniqueness",
      unique: true
    )
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index(
      ["key"],
      name: "index_active_storage_blobs_on_key",
      unique: true
    )
  end

end
