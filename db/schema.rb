# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_18_170358) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.string "prefix_name"
    t.string "slug"
    t.boolean "is_active", default: true
    t.boolean "is_deleted", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.integer "serial", null: false
    t.string "name"
    t.string "description"
    t.integer "status", null: false
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "total_time"
    t.bigint "user_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_tasks_on_category_id"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "tracking_times", force: :cascade do |t|
    t.bigint "task_id", null: false
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["task_id"], name: "index_tracking_times_on_task_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "name"
    t.string "encrypted_password"
    t.string "reset_password_token"
    t.string "photo"
    t.bigint "brand_id", null: false
    t.string "slug"
    t.date "dob"
    t.string "address"
    t.boolean "is_deleted", default: false
    t.boolean "is_active", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["brand_id"], name: "index_users_on_brand_id"
  end

  add_foreign_key "categories", "users"
  add_foreign_key "tasks", "categories"
  add_foreign_key "tasks", "users"
  add_foreign_key "tracking_times", "tasks"
  add_foreign_key "users", "brands"
end
