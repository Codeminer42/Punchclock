FactoryGirl.define do
  factory :admin_user do
    email { Faker::Internet.email }
    password { Faker::Lorem.characters(8) }
    company_id { Company.create(name:Faker::Company.name).id }
  end
end