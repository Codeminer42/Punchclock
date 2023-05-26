# frozen_string_literal: true

FactoryBot.define do
  factory :talk do
    event_name { Faker::Lorem.sentence }
    talk_title { Faker::Lorem.sentence }
    date { Faker::Date.between(from: 5.year.ago, to: 1.day.ago) }
    user

    trait :invalid_talk do
      event_name { nil }
      talk_title { nil }
      date { nil }
    end

    trait :with_future_date do
      date { Date.today.next_day }
    end
  end
end
