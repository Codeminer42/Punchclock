FactoryBot.define do
  factory :state do
    name { Faker::Address.state }
    sequence(:code) { |i| "#{Faker::Address.state_abbr}-#{i}" }
  end
end
