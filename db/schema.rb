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

ActiveRecord::Schema.define(version: 20150307141600) do

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "carts", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "location_id"
  end

  add_index "carts", ["location_id"], name: "index_carts_on_location_id", using: :btree
  add_index "carts", ["user_id"], name: "index_carts_on_user_id", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name",           default: "", null: false
    t.integer  "restaurant_id"
    t.integer  "parent_id"
    t.integer  "lft",                         null: false
    t.integer  "rgt",                         null: false
    t.integer  "depth",          default: 0,  null: false
    t.integer  "children_count", default: 0,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["restaurant_id"], name: "index_categories_on_restaurant_id", using: :btree

  create_table "line_items", force: true do |t|
    t.integer  "product_id"
    t.integer  "count",      default: 1, null: false
    t.integer  "cart_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order_id"
  end

  add_index "line_items", ["cart_id"], name: "index_line_items_on_cart_id", using: :btree
  add_index "line_items", ["order_id"], name: "index_line_items_on_order_id", using: :btree
  add_index "line_items", ["product_id"], name: "index_line_items_on_product_id", using: :btree

  create_table "locations", force: true do |t|
    t.string   "name",                                 default: "",  null: false
    t.string   "img"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "latitude",   precision: 30, scale: 20, default: 0.0, null: false
    t.decimal  "longitude",  precision: 30, scale: 20, default: 0.0, null: false
    t.decimal  "radius",     precision: 8,  scale: 6,  default: 0.0, null: false
  end

  create_table "locations_restaurants", force: true do |t|
    t.integer "location_id"
    t.integer "restaurant_id"
  end

  create_table "orders", force: true do |t|
    t.integer  "user_id"
    t.string   "address",                                         default: "",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.text     "driver_instructions"
    t.integer  "location_id"
    t.text     "restaurant_instructions"
    t.string   "contact_name",                                    default: "",  null: false
    t.string   "contact_phone",                                   default: "",  null: false
    t.decimal  "delivery_fee",            precision: 8, scale: 2, default: 0.0, null: false
  end

  add_index "orders", ["location_id"], name: "index_orders_on_location_id", using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "products", force: true do |t|
    t.string   "name",                                default: "",  null: false
    t.decimal  "price",       precision: 8, scale: 2, default: 0.0, null: false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
  end

  add_index "products", ["category_id"], name: "index_products_on_category_id", using: :btree

  create_table "related_products", force: true do |t|
    t.integer "product_id",         null: false
    t.integer "related_product_id", null: false
  end

  create_table "restaurants", force: true do |t|
    t.string   "name",       default: "", null: false
    t.string   "img"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone",      default: "", null: false
    t.string   "work_time",  default: "", null: false
  end

  create_table "settings", force: true do |t|
    t.string   "name",       default: "", null: false
    t.string   "value",      default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "phone",                  default: "", null: false
    t.string   "name",                   default: "", null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
