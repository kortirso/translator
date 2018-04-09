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

ActiveRecord::Schema.define(version: 2018_04_09_025153) do

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

  create_table "frameworks", force: :cascade do |t|
    t.string "name"
    t.string "extension"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "service", default: ""
  end

  create_table "identities", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "locales", force: :cascade do |t|
    t.string "code"
    t.string "country_code"
    t.hstore "names"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "positions", force: :cascade do |t|
    t.integer "task_id"
    t.integer "translation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_positions_on_task_id"
    t.index ["translation_id"], name: "index_positions_on_translation_id"
  end

  create_table "tasks", id: :serial, force: :cascade do |t|
    t.string "uid", default: "", null: false
    t.string "status", default: "verification", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "from", default: "", null: false
    t.string "to", default: "", null: false
    t.integer "user_id"
    t.integer "error"
    t.boolean "double", default: false
    t.integer "framework_id"
    t.index ["framework_id"], name: "index_tasks_on_framework_id"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "translations", id: :serial, force: :cascade do |t|
    t.integer "base_id"
    t.integer "result_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "direction", default: "", null: false
    t.boolean "verified", default: false
    t.index ["base_id"], name: "index_translations_on_base_id"
    t.index ["result_id"], name: "index_translations_on_result_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "access_token"
    t.string "role", default: "user", null: false
    t.index ["access_token"], name: "index_users_on_access_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "words", id: :serial, force: :cascade do |t|
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "locale_id"
    t.index ["locale_id"], name: "index_words_on_locale_id"
  end

end
