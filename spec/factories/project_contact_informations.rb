FactoryBot.define do
  factory :project_contact_information do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.phone_number }
    project
  end
end
