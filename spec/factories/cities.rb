FactoryBot.define do
  factory :city do
    sequence(:name) {|i| "City Name #{i}" }
    state { create(:state) }

    trait :with_holidays do
      regional_holidays { create_list(:regional_holiday, 5) }
    end
  end
end
