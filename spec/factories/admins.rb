FactoryGirl.define do
  factory :admin_user do
    email { Faker::Internet.email }
    password { Faker::Lorem.characters(8) }
    company { FactoryGirl.create(:company) }
  end
end