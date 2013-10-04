FactoryGirl.define do
  factory :project do
    name { Faker::Company.name }
    company
  end
end