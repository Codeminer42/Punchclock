# frozen_string_literal: true

FactoryBot.define do
  factory :user_skill do
    user
    skill
    experience_level { UserSkill.experience_level.values.sample }
  end
end
