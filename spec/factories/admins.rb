FactoryBot.define do
  factory :admin_user do
    email { Faker::Internet.email }
    password { Faker::Lorem.characters(8) }
    company

    trait :super do
      is_super true
    end
  end
end
