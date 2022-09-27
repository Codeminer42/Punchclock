FactoryBot.define do
  factory :city do
    sequence(:name) {|i| "City Name #{i}" }
    state { create(:state) }
  end
end
