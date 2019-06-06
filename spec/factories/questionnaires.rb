# frozen_string_literal: true

FactoryBot.define do
  factory :questionnaire do
    title       { Faker::Lorem.unique.sentence(3) }
    description { Faker::Lorem.paragraph }
    kind        { 'performance' }
    active      { true }
    company

    trait :kind_english do
      kind { 'english'}
    end

    trait :with_questions do
      transient do
        question_count { 3 }
      end
      questions { create_list :question, question_count, :multiple_choice }
    end
  end
end
