# frozen_string_literal: true

FactoryBot.define do
  factory :talking do
    event_name { 'some name' }
    talk_title { 'some trile' }
    date { Date.today }
    user

    trait :invalid_talking do
      event_name { nil }
      talk_title { nil }
      date { nil }
    end

    trait :with_future_date do
      date { Date.today.next_day }
    end
  end
end
