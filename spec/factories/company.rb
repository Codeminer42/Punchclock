FactoryBot.define do
  factory :company do
    name { Faker::Company.unique.name }
  end
end
