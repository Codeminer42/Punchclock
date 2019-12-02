FactoryBot.define do
  factory :review do
    user { create(:user) }
    contribution { create(:contribution) }
    state { :received }

    trait :rejected do
      state { :reject }
    end

    trait :approved do
      state { :approve }
    end
  end
end
