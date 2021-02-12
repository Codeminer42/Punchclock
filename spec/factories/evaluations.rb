# frozen_string_literal: true

FactoryBot.define do
  factory :evaluation do
    company
    evaluator   { create(:user, company: company) }
    evaluated   { create(:user, company: company) }
    questionnaire
    score       { rand 1..10 }
    observation { Faker::Lorem.paragraph }
    evaluation_date { Faker::Date.between(from: 2.days.ago, to: Date.today) }

    trait :with_answers do |evaluation|
      transient do
        answer_count { 3 }
      end

      answers { create_list :answer, answer_count}
    end

    trait :english do
      english_level { Evaluation.english_level.values.sample }
      questionnaire { create(:questionnaire, :kind_english) }
    end

    trait :performance do
      questionnaire { create(:questionnaire) }
    end
  end
end
