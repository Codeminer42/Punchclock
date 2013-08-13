FactoryGirl.define do
  factory :punch do
    from { DateTime.new(2001, 1, 1, 8, 0) }
    to { DateTime.new(2001, 1, 1, 17, 0) }
    project { FactoryGirl.create(:project) }
    user { FactoryGirl.create(:user) }
  end
end