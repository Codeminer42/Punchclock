FactoryBot.define do
  factory :office do
    city { Faker::Address.city }
    company
  end

end
