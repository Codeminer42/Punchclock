# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_10_06_131621) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "allocations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "project_id", null: false
    t.date "start_at", null: false
    t.date "end_at", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "ongoing", default: true
    t.integer "hourly_rate_cents", default: 0, null: false
    t.string "hourly_rate_currency", default: "BRL", null: false
    t.index ["project_id"], name: "index_allocations_on_project_id"
    t.index ["user_id"], name: "index_allocations_on_user_id"
  end

  create_table "answers", force: :cascade do |t|
    t.bigint "evaluation_id"
    t.bigint "question_id"
    t.text "response"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["evaluation_id"], name: "index_answers_on_evaluation_id"
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "state_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["state_id"], name: "index_cities_on_state_id"
  end

  create_table "contributions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "company_id"
    t.string "link", null: false
    t.string "state", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "repository_id"
    t.bigint "reviewer_id"
    t.datetime "reviewed_at", precision: nil
    t.string "pr_state"
    t.index ["company_id"], name: "index_contributions_on_company_id"
    t.index ["link"], name: "index_contributions_on_link", unique: true
    t.index ["repository_id"], name: "index_contributions_on_repository_id"
    t.index ["reviewer_id"], name: "index_contributions_on_reviewer_id"
    t.index ["user_id"], name: "index_contributions_on_user_id"
  end

  create_table "evaluations", force: :cascade do |t|
    t.bigint "questionnaire_id"
    t.integer "evaluator_id"
    t.integer "evaluated_id"
    t.text "observation"
    t.integer "score"
    t.integer "english_level"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.date "evaluation_date"
    t.index ["questionnaire_id"], name: "index_evaluations_on_questionnaire_id"
  end

  create_table "notes", force: :cascade do |t|
    t.text "comment"
    t.string "rate"
    t.bigint "user_id"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.index ["author_id"], name: "index_notes_on_author_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "offices", id: :serial, force: :cascade do |t|
    t.string "city"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
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
    t.string "name", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "company_id"
    t.boolean "active", default: true
    t.string "market"
    t.index ["company_id"], name: "index_projects_on_company_id"
    t.index ["name", "company_id"], name: "index_projects_on_name_and_company_id", unique: true
  end

  create_table "punches", id: :serial, force: :cascade do |t|
    t.datetime "from", precision: nil
    t.datetime "to", precision: nil
    t.integer "project_id"
    t.integer "user_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "company_id"
    t.string "attachment", limit: 255
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "questions", force: :cascade do |t|
    t.bigint "questionnaire_id"
    t.string "title"
    t.integer "kind"
    t.string "answer_options", default: [], array: true
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["questionnaire_id"], name: "index_questions_on_questionnaire_id"
  end

  create_table "regional_holidays", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "day"
    t.integer "month"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "repositories", force: :cascade do |t|
    t.string "link", null: false
    t.bigint "company_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "language"
    t.index ["company_id", "link"], name: "index_repositories_on_company_id_and_link", unique: true
    t.index ["company_id"], name: "index_repositories_on_company_id"
  end

  create_table "skills", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "skills_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "skill_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["skill_id"], name: "index_skills_users_on_skill_id"
    t.index ["user_id"], name: "index_skills_users_on_user_id"
  end

  create_table "states", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_states_on_code", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "name", limit: 255
    t.string "encrypted_password", limit: 255, default: ""
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "company_id"
    t.string "confirmation_token", limit: 255
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.boolean "active", default: true
    t.integer "mentor_id"
    t.integer "level"
    t.boolean "allow_overtime", default: false
    t.integer "office_id"
    t.integer "occupation"
    t.text "observation"
    t.integer "specialty"
    t.string "github"
    t.integer "contract_type", default: 1
    t.date "started_at"
    t.string "encrypted_otp_secret"
    t.string "encrypted_otp_secret_iv"
    t.string "encrypted_otp_secret_salt"
    t.integer "consumed_timestep"
    t.boolean "otp_required_for_login"
    t.string "otp_backup_codes", array: true
    t.string "otp_secret"
    t.integer "roles", array: true
    t.integer "contract_company_country"
    t.bigint "city_id"
    t.index ["city_id"], name: "index_users_on_city_id"
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["github"], name: "index_users_on_github", unique: true
    t.index ["mentor_id"], name: "index_users_on_mentor_id"
    t.index ["office_id"], name: "index_users_on_office_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "allocations", "projects"
  add_foreign_key "allocations", "users"
  add_foreign_key "answers", "evaluations"
  add_foreign_key "answers", "questions"
  add_foreign_key "cities", "states"
  add_foreign_key "contributions", "repositories"
  add_foreign_key "contributions", "users"
  add_foreign_key "evaluations", "questionnaires"
  add_foreign_key "notes", "users"
  add_foreign_key "notes", "users", column: "author_id"
  add_foreign_key "questions", "questionnaires"
  add_foreign_key "skills_users", "skills"
  add_foreign_key "skills_users", "users"
  add_foreign_key "users", "cities"
  add_foreign_key "users", "offices"
  add_foreign_key "users", "users", column: "mentor_id"
end
