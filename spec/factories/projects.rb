FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "#{Faker::App.name}#{n}" }
    company
  end

  trait :active do
    active { true }
  end

  trait :inactive do
    active { false }
  end
end
