FactoryGirl.define do
  factory :office do
    city { Faker::Address.city }
  end

end
