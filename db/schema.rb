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

ActiveRecord::Schema.define(version: 20180106231946) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "species", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index(
      ["name"],
      unique: true,
      using: :btree
    )
    t.integer  "lock_version", null: false, :default => 0
  end

  create_table "toy_types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index(
      ["name"],
      unique: true,
      using: :btree
    )
    t.integer  "lock_version", null: false, :default => 0
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
      index: true,
      null: false
    )
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "lock_version", null: false, :default => 0
  end

  create_table "toys", force: :cascade do |t|
    t.date "acquired_on", null: false
    t.references(
      :animal,
      foreign_key: {
        name: "toys_fk_animals",
        on_delete: :cascade
      },
      index: true,
      null: false,
    )
    t.references(
      :toy_type,
      foreign_key: {
        name: "toys_fk_toy_types"
      },
      index: true,
      null: false
    )
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "lock_version", null: false, :default => 0
  end

  create_table "people", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.date "birth_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "lock_version", null: false, :default => 0
  end

  create_table "pet_ownerships", force: :cascade do |t|
    t.date "adopted_on", null: false
    t.references(
      :animal,
      foreign_key: {
        name: "pet_ownerships_fk_animals",
      },
      index: true,
      null: false,
    )
    t.references(
      :person,
      foreign_key: {
        name: "pet_ownerships_fk_people",
      },
      index: true,
      null: false,
    )
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "lock_version", null: false, :default => 0
  end

end
