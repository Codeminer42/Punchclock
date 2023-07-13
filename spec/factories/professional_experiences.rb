# frozen_string_literal: true

FactoryBot.define do
  factory :professional_experience do
    user
    company { Faker::Company.name }
    position { Faker::Job.title }
    description { Faker::Lorem.paragraph }
    responsibilities { Faker::Lorem.sentences.join(' ') }
    start_date { '08/2015' }
    end_date { '10/2019' }

    trait :ended do
      start_date { '08/2016' }
      end_date { '10/2020' }
    end

    trait :ongoing do
      start_date { '10/2021' }
      end_date { "10/#{Date.current.year + 2}" }
    end
  end
end
