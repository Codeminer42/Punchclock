FactoryBot.define do
  factory :user do
    name                  { Faker::Name.unique.name }
    email                 { Faker::Internet.unique.email }
    password              { 'password' }
    password_confirmation { 'password' }
    occupation            { 'engineer' }
    level                 { 'junior' }
    specialty             { 'backend' }
    github                { 'gitUser' }
    hour_cost             { 15.0 }
    contract_type         { 'employee' }
    role                  { 'user' }
    association :office, factory: :office
    company

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
      admin { true }
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
      after(:create) do |user|
        create(:evaluation, score: 5, evaluated: user)
        create(:evaluation, :english, score: 10, evaluated: user)
      end
    end
  end

  factory :invalid_user, parent: :user do
    name { nil }
  end
end
