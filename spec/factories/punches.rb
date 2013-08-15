FactoryGirl.define do
  factory :punch do
    from { Time.new(2001, 1, 1, 8, 0, 0, 0) }
    to { Time.new(2001, 1, 1, 17, 0, 0, 0) }
    project { FactoryGirl.create(:project) }
    user { FactoryGirl.create(:user) }
  end
end