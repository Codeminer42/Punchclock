FactoryBot.define do
  factory :office do
    city { Faker::Address.city }
    company

    trait :with_holiday do
      after :create do |office|
        office.regional_holidays = create_list(:regional_holiday, 5)
      end
    end
  end
end
