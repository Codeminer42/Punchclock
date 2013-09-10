FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Lorem.characters(8) }
    company { FactoryGirl.create(:company) }
  end
end