# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :period do
    start_at "2014-04-18"
    end_at "2014-04-18"
    company nil
  end
end
