FactoryGirl.define do
  factory :project do
    name { Faker::Company.name }
    company
  end

  trait :active do
     active true
   end

   trait :inactive do
     active false
   end
end
