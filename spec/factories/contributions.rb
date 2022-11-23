# frozen_string_literal: true

FactoryBot.define do
  factory :contribution do
    user
    repository 
    state { :received }
    rejected_reason { nil }
    pr_state { :open }
    sequence :link do |n|
      "https://www.github.com/company/example-#{n}/pull/#{n}"
    end
    
    trait :rejected do
      state { :reject }
    end

    trait :approved do
      state { :approved }
    end

    trait :allocated_in_the_project do
      rejected_reason { :allocated_in_the_project }
    end

    trait :project_is_not_on_the_curated_list do
      rejected_reason { :project_is_not_on_the_curated_list }
    end

    trait :no_sufficient_effort do
      rejected_reason { :no_sufficient_effort }
    end

    trait :pr_abandoned do
      rejected_reason { :pr_abandoned }
    end

    trait :other_reason do
      rejected_reason { :other_reason }
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
