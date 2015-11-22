# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151122152624) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string   "name"
    t.text     "full_address"
    t.string   "pincode"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "locality"
    t.string   "city"
  end

  add_index "addresses", ["user_id"], name: "index_addresses_on_user_id", using: :btree

  create_table "deliveries", force: :cascade do |t|
    t.date     "delivery_date"
    t.time     "at"
    t.integer  "collect"
    t.integer  "user_id"
    t.integer  "address_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "delivery_status_id"
    t.date     "payment_date"
    t.string   "payment_mode"
    t.string   "booking_no"
    t.integer  "payment_status_id"
    t.integer  "subscription_id"
  end

  add_index "deliveries", ["address_id"], name: "index_deliveries_on_address_id", using: :btree
  add_index "deliveries", ["user_id"], name: "index_deliveries_on_user_id", using: :btree

  create_table "delivery_statuses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "food_alerts", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "food_alerts", ["user_id"], name: "index_food_alerts_on_user_id", using: :btree

  create_table "food_alerts_items", id: false, force: :cascade do |t|
    t.integer "food_item_id"
    t.integer "food_alert_id"
  end

  add_index "food_alerts_items", ["food_alert_id"], name: "index_food_alerts_items_on_food_alert_id", using: :btree
  add_index "food_alerts_items", ["food_item_id"], name: "index_food_alerts_items_on_food_item_id", using: :btree

  create_table "food_items", force: :cascade do |t|
    t.string   "name"
    t.string   "veg_non_egg"
    t.text     "description"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "course"
    t.boolean  "show_image"
  end

  create_table "food_items_kickerrs", id: false, force: :cascade do |t|
    t.integer "food_item_id"
    t.integer "kickerr_id"
  end

  add_index "food_items_kickerrs", ["food_item_id"], name: "index_food_items_kickerrs_on_food_item_id", using: :btree
  add_index "food_items_kickerrs", ["kickerr_id"], name: "index_food_items_kickerrs_on_kickerr_id", using: :btree

  create_table "ingredients", force: :cascade do |t|
    t.integer  "raw_material_id"
    t.integer  "food_item_id"
    t.float    "quantity"
    t.string   "unit"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "kickerrs", force: :cascade do |t|
    t.string   "name"
    t.integer  "price"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "veg_type"
  end

  create_table "menus", force: :cascade do |t|
    t.date     "available_on"
    t.integer  "kickerr_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "price"
    t.integer  "expected_consumption"
  end

  add_index "menus", ["kickerr_id"], name: "index_menus_on_kickerr_id", using: :btree

  create_table "packs", force: :cascade do |t|
    t.integer  "quantity"
    t.integer  "menu_id"
    t.integer  "delivery_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "unit_price"
  end

  add_index "packs", ["delivery_id"], name: "index_packs_on_delivery_id", using: :btree
  add_index "packs", ["menu_id"], name: "index_packs_on_menu_id", using: :btree

  create_table "payment_statuses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "raw_materials", force: :cascade do |t|
    t.string   "name"
    t.string   "veg_non_egg"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id"
    t.time     "at"
    t.date     "start_date"
    t.integer  "address_id"
    t.integer  "veg_qty"
    t.integer  "egg_qty"
    t.integer  "non_veg_qty"
    t.integer  "payment_status_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "no_of_days"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone_number"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",             default: false
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.string   "source"
    t.integer  "deliveries_count",  default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  add_foreign_key "addresses", "users"
  add_foreign_key "deliveries", "addresses"
  add_foreign_key "deliveries", "users"
  add_foreign_key "menus", "kickerrs"
  add_foreign_key "packs", "deliveries"
  add_foreign_key "packs", "menus"
end
