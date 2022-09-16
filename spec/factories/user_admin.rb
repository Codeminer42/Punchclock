FactoryBot.define do
  factory :user_admin, class: User do
    name { Faker::Internet.name }
    email    { Faker::Internet.unique.email }
    password { Faker::Lorem.characters(number: 8) }
  end
end
