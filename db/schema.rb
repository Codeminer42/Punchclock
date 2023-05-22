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

ActiveRecord::Schema[7.0].define(version: 2023_05_12_124753) do
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

  create_table "cities_regional_holidays", id: false, force: :cascade do |t|
    t.bigint "city_id", null: false
    t.bigint "regional_holiday_id", null: false
    t.index ["city_id", "regional_holiday_id"], name: "index_cities_on_regional_holidays", unique: true
    t.index ["regional_holiday_id", "city_id"], name: "index_regional_holidays_on_cities", unique: true
  end

  create_table "contributions", force: :cascade do |t|
    t.bigint "user_id"
    t.string "link", null: false
    t.string "state", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "repository_id"
    t.bigint "reviewer_id"
    t.datetime "reviewed_at", precision: nil
    t.string "pr_state"
    t.integer "rejected_reason"
    t.boolean "tracking", default: false, null: false
    t.text "notes"
    t.text "description"
    t.string "pending"
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
    t.integer "users_count", default: 0
    t.float "score"
    t.integer "head_id"
    t.boolean "active", default: true
  end

  create_table "projects", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "active", default: true
    t.string "market"
  end

  create_table "punches", id: :serial, force: :cascade do |t|
    t.datetime "from", precision: nil
    t.datetime "to", precision: nil
    t.integer "project_id"
    t.integer "user_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "attachment"
    t.text "comment"
    t.boolean "extra_hour", default: false, null: false
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "language"
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
    t.string "email", default: "", null: false
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "name"
    t.string "encrypted_password", default: ""
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.string "confirmation_token"
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
    t.bigint "city_id"
    t.integer "roles", array: true
    t.integer "contract_company_country"
    t.index ["city_id"], name: "index_users_on_city_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["github"], name: "index_users_on_github", unique: true
    t.index ["mentor_id"], name: "index_users_on_mentor_id"
    t.index ["office_id"], name: "index_users_on_office_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vacations", force: :cascade do |t|
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.integer "status", default: 0
    t.bigint "user_id", null: false
    t.bigint "hr_approver_id"
    t.bigint "commercial_approver_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "denier_id"
    t.index ["commercial_approver_id"], name: "index_vacations_on_commercial_approver_id"
    t.index ["denier_id"], name: "index_vacations_on_denier_id"
    t.index ["hr_approver_id"], name: "index_vacations_on_hr_approver_id"
    t.index ["user_id"], name: "index_vacations_on_user_id"
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
  add_foreign_key "vacations", "users"
  add_foreign_key "vacations", "users", column: "commercial_approver_id"
  add_foreign_key "vacations", "users", column: "denier_id"
  add_foreign_key "vacations", "users", column: "hr_approver_id"
end
