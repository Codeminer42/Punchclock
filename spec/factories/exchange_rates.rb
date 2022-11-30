FactoryBot.define do
  factory :exchange_rate do
    month { rand(1..12) }
    year { rand(2011..2025) }
    currency { 'USD' }
    rate { Faker::Number.decimal }
  end
end
