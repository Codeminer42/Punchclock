# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    questionnaire
    title { Faker::Lorem.word }
    raw_answer_options { 'Answer; Options' }
    kind               { :multiple_choice }

    trait :multiple_choice do
      raw_answer_options { 'Answer; Options' }
      kind               { :multiple_choice }
    end
  end
end
