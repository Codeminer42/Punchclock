FactoryBot.define do
  factory :company do
    name { Faker::Company.name }
  end
end
