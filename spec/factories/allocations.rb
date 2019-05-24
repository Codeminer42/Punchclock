# frozen_string_literal: true

FactoryBot.define do
  factory :allocation do
    user
    project
    start_at { Date.today }
    end_at   { nil }
    company { user.company }

    trait :with_end_at do
      end_at { Faker::Date.between(Date.tomorrow, 4.days.after) }
    end
  end
end
