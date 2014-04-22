FactoryGirl.define do
  factory :super, class: AdminUser do
    email { Faker::Internet.email }
    password { Faker::Lorem.characters(8) }
    company
    is_super { true }
  end
end
