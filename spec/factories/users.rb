FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Lorem.characters(8) }
    company
    hour_cost { 15.0 }
  end
end