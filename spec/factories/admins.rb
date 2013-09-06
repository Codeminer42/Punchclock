FactoryGirl.define do
  factory :admin do
    email { Faker::Internet.email }
    password { Faker::Lorem.characters(8) }
    company_id { Company.create(name:Faker::Name.name).id }
  end
end