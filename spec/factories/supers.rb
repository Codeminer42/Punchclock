FactoryGirl.define do
  factory :super do
    email { Faker::Internet.email }
    password { Faker::Lorem.characters(8) }
    company_id { Company.create(name:Faker::Name.name).id }
    is_super { true }
  end
end