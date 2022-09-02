FactoryBot.define do
  factory :state do
    name { Faker::Address.state }
    code { Faker::Address.state_abbr }
  end
end
