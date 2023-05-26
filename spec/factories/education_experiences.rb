# frozen_string_literal: true
FactoryBot.define do
  factory :education_experience do
    user
    institution { Faker::Educator.school_name }
    course { Faker::Educator.course_name }
    start_date { 8.years.ago }
    end_date { 4.years.ago }

    trait :ended do
      start_date { 8.years.ago }
      end_date { 4.years.ago }
    end

    trait :ongoing do
      start_date { 1.years.ago }
      end_date { 4.years.from_now }
    end
  end
end
