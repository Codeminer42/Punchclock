# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    evaluation
    question
    response { Faker::Lorem.paragraph }
  end
end
