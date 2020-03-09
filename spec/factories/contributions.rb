# frozen_string_literal: true

FactoryBot.define do
  factory :contribution do
    user { create(:user) }
    company { create(:company) }
    state { :received }
    sequence :link do |n| 
      "https://www.github.com/company/example-#{n}/pull/#{n}"
    end

    trait :rejected do
      state { :reject }
    end

    trait :approved do
      state { :approved }
    end

    trait :with_valid_repository do
      before(:create) do |contribution|
        create(:repository,
                link: contribution.link.sub(/\/pull\/[0-9]*/, ''),
                company: contribution.company)
      end
    end
  end
end
