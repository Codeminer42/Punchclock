# frozen_string_literal: true

FactoryBot.define do
  factory :contribution do
    user { create(:user) }
    company { create(:company) }
    state { :received }
    link { Faker::Internet.url(host: 'github.com/example/pull/') }

    trait :rejected do
      state { :reject }
    end

    trait :approved do
      state { :approved }
    end
  end
end
