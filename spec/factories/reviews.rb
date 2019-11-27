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

    trait :closed do
      state { :close }
    end

    trait :contested do
      state { :contest }
    end
  end
end
