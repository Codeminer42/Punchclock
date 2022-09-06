FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "#{Faker::App.name}#{n}" }
    market { Project.market.values.sample }
    company
  end

  trait :active do
    active { true }
  end

  trait :inactive do
    active { false }
  end
end
