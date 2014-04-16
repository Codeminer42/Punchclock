FactoryGirl.define do
  factory :user_admin, class: User do
  	 name { Faker::Internet.name }
    email { Faker::Internet.email }
    password { Faker::Lorem.characters(8) }
    company
    is_admin { true }
  end
end
