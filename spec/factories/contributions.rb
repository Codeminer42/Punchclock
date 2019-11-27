# frozen_string_literal: true

FactoryBot.define do
  factory :contribution do
    user { create(:user) }
    office { create(:office) }
    state { 'received' }
    link { Faker::Internet.url(host: 'github.com') }

    trait :rejected do
      state { 'reject' }
    end

    trait :approved do
      state { 'approve' }
    end

    trait :closed do
      state { 'close' }
    end

    trait :contested do
      state { 'contest' }
    end
  end
end
