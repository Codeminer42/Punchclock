# frozen_string_literal: true
FactoryBot.define do
  factory :office do
    city { Faker::Address.unique.city }

    trait :with_head do
      head { create(:user) }
    end
  end

  factory :invalid_office, parent: :office do |i|
    i.city { nil }
  end
end
