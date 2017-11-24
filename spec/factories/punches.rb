FactoryGirl.define do
  factory :punch do
    sequence(:from) { |i| DateTime.new(2001, 1, 5, 8, 0, 0, 0) }
    sequence(:to) { |i| DateTime.new(2001, 1, 5, 17, 0, 0, 0) }
    extra_hour '01:25'
    user
    project { FactoryGirl.create(:project, company: user.company) }
    company { user.company }
  end
end
