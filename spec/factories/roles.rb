FactoryBot.define do
  factory :role do
    name { Faker::Name.unique.name }
  end
end
