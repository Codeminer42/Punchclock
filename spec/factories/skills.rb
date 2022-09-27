# frozen_string_literal: true

FactoryBot.define do
  factory :skill do
    title { Faker::ProgrammingLanguage.unique.name}
  end
end
