FactoryGirl.define do
  factory :project do
    name { Faker::Company.name }
    company { FactoryGirl.create(:company) }
  end
end