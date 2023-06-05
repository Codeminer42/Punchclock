# frozen_string_literal: true

FactoryBot.define do
  factory :professional_experience do
    user
    company { Faker::Company.name }
    position { Faker::Job.title }
    description { Faker::Lorem.paragraph }
    responsibilities { Faker::Lorem.sentences.join(' ') }
    start_date { 8.years.ago }
    end_date { 4.years.ago }

    trait :ended do
      start_date { 8.years.ago }
      end_date { 4.years.ago }
    end

    trait :ongoing do
      start_date { 1.year.ago }
      end_date { 4.years.from_now }
    end
  end
end

