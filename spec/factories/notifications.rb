# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification do
    user
    from_user_id { FactoryGirl.create(:user, company: user.company).id }
    message "My Message"
    read false
  end
end
