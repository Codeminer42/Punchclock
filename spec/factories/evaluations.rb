FactoryGirl.define do
  factory :evaluation do
    user
    association :reviewer, factory: :user
    review { Faker::Lorem.characters(120) }
  end
end
