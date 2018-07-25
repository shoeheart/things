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
  enable_extension "hstore"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "animals", force: :cascade do |t|
    t.string "name", null: false
    t.date "birth_date", null: false
    t.boolean "is_vaccinated", null: false
    t.bigint "species_id", null: false
    t.boolean "is_deleted", default: false, null: false
    t.jsonb "log_data", null: false
    t.integer "lock_version", default: 0, null: false
    t.index ["species_id"], name: "index_animals_on_species_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "index_delayed_jobs_priority_run_at"
  end

  create_table "minerals", force: :cascade do |t|
    t.string "name"
    t.boolean "igneous"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.date "birth_date", null: false
    t.boolean "is_deleted", default: false, null: false
    t.jsonb "log_data", null: false
    t.integer "lock_version", default: 0, null: false
  end

  create_table "pet_ownerships", force: :cascade do |t|
    t.date "adopted_on", null: false
    t.bigint "animal_id", null: false
    t.bigint "person_id", null: false
    t.boolean "is_deleted", default: false, null: false
    t.jsonb "log_data", null: false
    t.integer "lock_version", default: 0, null: false
    t.index ["animal_id"], name: "index_pet_ownerships_animal", unique: true, where: "is_deleted"
    t.index ["animal_id"], name: "index_pet_ownerships_on_animal_id"
    t.index ["person_id"], name: "index_pet_ownerships_on_person_id"
  end

  create_table "species", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "is_deleted", default: false, null: false
    t.jsonb "log_data", null: false
    t.integer "lock_version", default: 0, null: false
    t.index ["name"], name: "index_species_on_name", unique: true
  end

  create_table "toy_types", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "is_deleted", default: false, null: false
    t.jsonb "log_data", null: false
    t.integer "lock_version", default: 0, null: false
    t.index ["name"], name: "index_toy_types_on_name", unique: true
  end

  create_table "toys", force: :cascade do |t|
    t.date "acquired_on", null: false
    t.bigint "animal_id", null: false
    t.bigint "toy_type_id", null: false
    t.boolean "is_deleted", default: false, null: false
    t.jsonb "log_data", null: false
    t.integer "lock_version", default: 0, null: false
    t.index ["animal_id"], name: "index_toys_on_animal_id"
    t.index ["toy_type_id"], name: "index_toys_on_toy_type_id"
  end

  add_foreign_key "animals", "species", name: "animals_fk_species"
  add_foreign_key "pet_ownerships", "animals", name: "pet_ownerships_fk_animals"
  add_foreign_key "pet_ownerships", "people", name: "pet_ownerships_fk_people"
  add_foreign_key "toys", "animals", name: "toys_fk_animals", on_delete: :cascade
  add_foreign_key "toys", "toy_types", name: "toys_fk_toy_types"
end
