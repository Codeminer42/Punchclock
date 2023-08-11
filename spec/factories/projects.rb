FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "#{Faker::App.name}#{n}" }
    market { Project.market.values.sample }
  end

  trait :active do
    active { true }
  end

  trait :inactive do
    active { false }
  end

  trait :internal do
    market { :internal }
  end

  trait :international do
    market { :international }
  end
end
