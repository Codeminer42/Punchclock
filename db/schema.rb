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

ActiveRecord::Schema.define(version: 2021_05_21_111224) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "allocations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "project_id", null: false
    t.date "start_at", null: false
    t.date "end_at"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_allocations_on_company_id"
    t.index ["project_id"], name: "index_allocations_on_project_id"
    t.index ["user_id"], name: "index_allocations_on_user_id"
  end

  create_table "answers", force: :cascade do |t|
    t.bigint "evaluation_id"
    t.bigint "question_id"
    t.text "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["evaluation_id"], name: "index_answers_on_evaluation_id"
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "clients", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.index ["company_id"], name: "index_clients_on_company_id"
  end

  create_table "companies", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "avatar"
    t.integer "end_period"
  end

  create_table "contributions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "company_id"
    t.string "link", null: false
    t.string "state", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "repository_id"
    t.index ["company_id"], name: "index_contributions_on_company_id"
    t.index ["link"], name: "index_contributions_on_link", unique: true
    t.index ["repository_id"], name: "index_contributions_on_repository_id"
    t.index ["user_id"], name: "index_contributions_on_user_id"
  end

  create_table "evaluations", force: :cascade do |t|
    t.bigint "questionnaire_id"
    t.integer "evaluator_id"
    t.integer "evaluated_id"
    t.text "observation"
    t.integer "score"
    t.integer "english_level"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "evaluation_date"
    t.index ["company_id"], name: "index_evaluations_on_company_id"
    t.index ["questionnaire_id"], name: "index_evaluations_on_questionnaire_id"
  end

  create_table "notes", force: :cascade do |t|
    t.text "comment"
    t.string "rate"
    t.bigint "user_id"
    t.bigint "author_id"
    t.bigint "company_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_id"], name: "index_notes_on_author_id"
    t.index ["company_id"], name: "index_notes_on_company_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "offices", id: :serial, force: :cascade do |t|
    t.string "city"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "company_id"
    t.integer "users_count", default: 0
    t.float "score"
    t.integer "head_id"
    t.boolean "active", default: true
    t.index ["company_id"], name: "index_offices_on_company_id"
  end

  create_table "offices_regional_holidays", id: false, force: :cascade do |t|
    t.integer "office_id", null: false
    t.integer "regional_holiday_id", null: false
    t.index ["office_id", "regional_holiday_id"], name: "index_offices_on_regional_holidays"
    t.index ["regional_holiday_id", "office_id"], name: "index_regional_holidays_on_offices"
  end

  create_table "projects", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "company_id"
    t.boolean "active", default: true
    t.integer "client_id"
    t.index ["client_id"], name: "index_projects_on_client_id"
    t.index ["company_id"], name: "index_projects_on_company_id"
    t.index ["name", "company_id"], name: "index_projects_on_name_and_company_id", unique: true
  end

  create_table "punches", id: :serial, force: :cascade do |t|
    t.datetime "from"
    t.datetime "to"
    t.integer "project_id"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "company_id"
    t.string "attachment"
    t.text "comment"
    t.boolean "extra_hour", default: false, null: false
    t.index ["company_id"], name: "index_punches_on_company_id"
    t.index ["project_id"], name: "index_punches_on_project_id"
    t.index ["user_id"], name: "index_punches_on_user_id"
  end

  create_table "questionnaires", force: :cascade do |t|
    t.string "title"
    t.integer "kind"
    t.text "description"
    t.boolean "active"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_questionnaires_on_company_id"
  end

  create_table "questions", force: :cascade do |t|
    t.bigint "questionnaire_id"
    t.string "title"
    t.integer "kind"
    t.string "answer_options", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["questionnaire_id"], name: "index_questions_on_questionnaire_id"
  end

  create_table "regional_holidays", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "day"
    t.integer "month"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.index ["company_id"], name: "index_regional_holidays_on_company_id"
  end

  create_table "repositories", force: :cascade do |t|
    t.string "link", null: false
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "language"
    t.index ["company_id", "link"], name: "index_repositories_on_company_id_and_link", unique: true
    t.index ["company_id"], name: "index_repositories_on_company_id"
  end

  create_table "skills", force: :cascade do |t|
    t.string "title"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_skills_on_company_id"
    t.index ["title", "company_id"], name: "index_skills_on_title_and_company_id", unique: true
  end

  create_table "skills_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "skill_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["skill_id"], name: "index_skills_users_on_skill_id"
    t.index ["user_id"], name: "index_skills_users_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name"
    t.string "encrypted_password", default: ""
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "company_id"
    t.decimal "hour_cost", default: "0.0", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.boolean "active", default: true
    t.integer "reviewer_id"
    t.integer "level"
    t.boolean "allow_overtime", default: false
    t.integer "office_id"
    t.integer "occupation"
    t.text "observation"
    t.integer "specialty"
    t.string "github"
    t.integer "contract_type", default: 1
    t.integer "role", default: 0
    t.date "started_at"
    t.string "token"
    t.string "encrypted_otp_secret"
    t.string "encrypted_otp_secret_iv"
    t.string "encrypted_otp_secret_salt"
    t.integer "consumed_timestep"
    t.boolean "otp_required_for_login"
    t.string "otp_backup_codes", array: true
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["github"], name: "index_users_on_github", unique: true
    t.index ["office_id"], name: "index_users_on_office_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["reviewer_id"], name: "index_users_on_reviewer_id"
    t.index ["token"], name: "index_users_on_token", unique: true
  end

  add_foreign_key "allocations", "companies"
  add_foreign_key "allocations", "projects"
  add_foreign_key "allocations", "users"
  add_foreign_key "answers", "evaluations"
  add_foreign_key "answers", "questions"
  add_foreign_key "clients", "companies"
  add_foreign_key "contributions", "repositories"
  add_foreign_key "contributions", "users"
  add_foreign_key "evaluations", "companies"
  add_foreign_key "evaluations", "questionnaires"
  add_foreign_key "notes", "companies"
  add_foreign_key "notes", "users"
  add_foreign_key "notes", "users", column: "author_id"
  add_foreign_key "questionnaires", "companies"
  add_foreign_key "questions", "questionnaires"
  add_foreign_key "regional_holidays", "companies"
  add_foreign_key "skills", "companies"
  add_foreign_key "skills_users", "skills"
  add_foreign_key "skills_users", "users"
  add_foreign_key "users", "offices"
  add_foreign_key "users", "users", column: "reviewer_id"
end
