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

ActiveRecord::Schema.define(version: 20180111135512) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_super"
    t.integer  "company_id"
    t.index ["company_id"], name: "index_admin_users_on_company_id", using: :btree
    t.index ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "clients", force: :cascade do |t|
    t.string   "name"
    t.integer  "company_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "active",     default: true
    t.index ["company_id"], name: "index_clients_on_company_id", using: :btree
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar",     limit: 255
    t.integer  "end_period"
  end

  create_table "offices", force: :cascade do |t|
    t.string   "city"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "company_id"
    t.index ["company_id"], name: "index_offices_on_company_id", using: :btree
  end

  create_table "offices_regional_holidays", id: false, force: :cascade do |t|
    t.integer "office_id",           null: false
    t.integer "regional_holiday_id", null: false
    t.index ["office_id", "regional_holiday_id"], name: "index_offices_on_regional_holidays", using: :btree
    t.index ["regional_holiday_id", "office_id"], name: "index_regional_holidays_on_offices", using: :btree
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.boolean  "active",                 default: true
    t.integer  "client_id"
    t.index ["client_id"], name: "index_projects_on_client_id", using: :btree
    t.index ["company_id"], name: "index_projects_on_company_id", using: :btree
  end

  create_table "punches", force: :cascade do |t|
    t.datetime "from"
    t.datetime "to"
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.string   "attachment", limit: 255
    t.text     "comment"
    t.string   "extra_hour"
    t.index ["company_id"], name: "index_punches_on_company_id", using: :btree
    t.index ["project_id"], name: "index_punches_on_project_id", using: :btree
    t.index ["user_id"], name: "index_punches_on_user_id", using: :btree
  end

  create_table "regional_holidays", force: :cascade do |t|
    t.string   "name"
    t.integer  "day"
    t.integer  "month"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                   limit: 255
    t.string   "encrypted_password",     limit: 255, default: ""
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "company_id"
    t.decimal  "hour_cost",                          default: "0.0", null: false
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.boolean  "active",                             default: true
    t.boolean  "beta_access",                        default: false
    t.integer  "reviewer_id"
    t.integer  "role"
    t.boolean  "allow_overtime",                     default: false
    t.integer  "office_id"
    t.index ["company_id"], name: "index_users_on_company_id", using: :btree
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["office_id"], name: "index_users_on_office_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["reviewer_id"], name: "index_users_on_reviewer_id", using: :btree
  end

  add_foreign_key "clients", "companies"
  add_foreign_key "users", "offices"
  add_foreign_key "users", "users", column: "reviewer_id"
end
