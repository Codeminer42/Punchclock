# frozen_string_literal: true

FactoryBot.define do
  factory :contribution do
    user { create(:user) }
    repository { create(:repository) }
    state { :received }
    pr_state { :open }
    sequence :link do |n|
      "https://www.github.com/company/example-#{n}/pull/#{n}"
    end
    reviewed_at { nil }
    reviewed_by { nil }

    trait :rejected do
      state { :reject }
    end

    trait :approved do
      state { :approved }
    end

    trait :open_pr do
      pr_state { :open }
    end

    trait :merged_pr do
      pr_state { :merged }
    end

    trait :closed_pr do
      pr_state { :closed }
    end
  end
end
