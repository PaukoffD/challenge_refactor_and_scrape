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

ActiveRecord::Schema.define(version: 20151224113642) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounting_categories", force: :cascade do |t|
    t.integer  "accounting_type_id"
    t.string   "name"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "accounting_categories", ["accounting_type_id"], name: "index_accounting_categories_on_accounting_type_id", using: :btree

  create_table "accounting_categories_devices", id: false, force: :cascade do |t|
    t.integer "accounting_category_id", null: false
    t.integer "device_id",              null: false
  end

  create_table "accounting_types", force: :cascade do |t|
    t.integer  "customer_id"
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "accounting_types", ["customer_id"], name: "index_accounting_types_on_customer_id", using: :btree

  create_table "business_accounts", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "customer_id"
  end

  add_index "business_accounts", ["customer_id"], name: "index_business_accounts_on_customer_id", using: :btree

  create_table "carrier_bases", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delivery_companies", force: :cascade do |t|
    t.string   "name",         null: false
    t.string   "url",          null: false
    t.string   "form_name"
    t.string   "form_action"
    t.string   "field_name",   null: false
    t.string   "extra_fields"
    t.string   "extra_values"
    t.string   "submit"
    t.string   "xpath"
    t.text     "css"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "delivery_companies", ["name"], name: "index_delivery_companies_on_name", using: :btree
  add_index "delivery_companies", ["url"], name: "index_delivery_companies_on_url", using: :btree

  create_table "device_makes", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "device_models", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "devices", force: :cascade do |t|
    t.string   "number"
    t.integer  "customer_id"
    t.integer  "device_make_id"
    t.integer  "device_model_id"
    t.string   "status"
    t.string   "imei_number"
    t.string   "sim_number"
    t.string   "model"
    t.integer  "carrier_base_id"
    t.integer  "business_account_id"
    t.date     "contract_expiry_date"
    t.string   "username"
    t.string   "location"
    t.string   "email"
    t.string   "employee_number"
    t.string   "contact_id"
    t.boolean  "inactive"
    t.boolean  "in_suspension"
    t.boolean  "is_roaming"
    t.string   "additional_data_old"
    t.string   "added_features"
    t.string   "current_rate_plan"
    t.string   "data_usage_status"
    t.string   "transfer_to_personal_status"
    t.string   "apple_warranty"
    t.string   "eligibility_date"
    t.string   "number_for_forwarding"
    t.string   "call_forwarding_status"
    t.string   "asset_tag"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "created_by"
    t.string   "source"
  end

  add_index "devices", ["business_account_id"], name: "index_devices_on_business_account_id", using: :btree
  add_index "devices", ["carrier_base_id"], name: "index_devices_on_carrier_base_id", using: :btree
  add_index "devices", ["customer_id"], name: "index_devices_on_customer_id", using: :btree
  add_index "devices", ["device_make_id"], name: "index_devices_on_device_make_id", using: :btree
  add_index "devices", ["device_model_id"], name: "index_devices_on_device_model_id", using: :btree

  add_foreign_key "accounting_categories", "accounting_types"
  add_foreign_key "accounting_types", "customers"
  add_foreign_key "business_accounts", "customers"
  add_foreign_key "devices", "business_accounts"
  add_foreign_key "devices", "carrier_bases"
  add_foreign_key "devices", "customers"
  add_foreign_key "devices", "device_makes"
  add_foreign_key "devices", "device_models"
end
