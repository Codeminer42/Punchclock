FactoryBot.define do
  factory :user do
    name                  { Faker::Name.unique.name }
    email                 { Faker::Internet.unique.email }
    password              { 'password' }
    password_confirmation { 'password' }
    occupation            { 'engineer' }
    level                 { 'junior' }
    specialty             { 'backend' }
    github                { Faker::Internet.unique.username }
    contract_type         { 'employee' }
    roles                 { [:normal] }
    contract_company_country { 'brazil' }
    otp_required_for_login { false }
    office                { create(:office) }
    city

    trait :head_office do
      office { create(:office, head: :user) }
    end

    trait :without_office do
      office { nil }
    end

    trait :active_user do
      active { true }
    end

    trait :inactive_user do
      active { false }
    end

    trait :admin do
      roles { [:admin] }
    end

    trait :open_source_manager do
      roles { [:open_source_manager] }
    end

    trait :with_observation do
      observation { Faker::Lorem.sentence }
    end

    trait :with_allocation do
      after(:create) do |user|
        create_list(:allocation, 2, user: user)
      end
    end

    trait :with_overall_score do
      transient do
        score { 7 }
      end

      after(:create) do |user, evaluator|
        create(:evaluation, score: evaluator.score, evaluated: user)
        create(:evaluation, :english, score: evaluator.score, evaluated: user)
      end
    end

    trait :level_trainee do
      level { :trainee }
    end

     trait :level_intern do
      level { :intern }
    end

    trait :level_junior do
      level { :junior }
    end

    trait :level_junior_plus do
      level { :junior_plus }
    end

    trait :level_mid do
      level { :mid }
    end

    trait :level_mid_plus do
      level { :mid_plus }
    end

    trait :level_senior do
      level { :senior }
    end

    trait :level_senior_plus do
      level { :senior_plus }
    end

    trait :with_started_at do
      started_at { Date.today }
    end

    trait :with_skills do
      after(:create) do |user|
        user.skills = create_list(:skill, 2)
      end
    end
  end

  factory :invalid_user, parent: :user do
    name { nil }
  end
end
