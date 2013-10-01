# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    text "A comment on punch."
    user { FactoryGirl.create(:user) }
    punch { FactoryGirl.create(:punch, user: user, company: user.company) }
  end
end
