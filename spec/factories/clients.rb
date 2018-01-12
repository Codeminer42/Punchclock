FactoryBot.define do
  factory :client do
    name "MyString"
    company nil
  end

  trait :active_client do
    active true
  end

  trait :inactive_client do
    active false
  end
end
