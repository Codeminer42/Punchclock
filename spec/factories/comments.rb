FactoryGirl.define do
  factory :comment do
    text 'A comment on punch.'
    user
    punch { FactoryGirl.create(:punch, user: user, company: user.company) }
  end
end
