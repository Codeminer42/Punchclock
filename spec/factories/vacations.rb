FactoryBot.define do
  factory :vacation do
    start_date { 1.week.from_now.monday }
    end_date { 1.month.from_now }
    status { 'pending' }
    user
    hr_approver { nil }
    commercial_approver { nil }
    denier { nil }

    trait :approved do
      status { 'approved' }
    end

    trait :pending do
      status { 'pending' }
    end

    trait :cancelled do
      status { 'cancelled' }
    end

    trait :denied do
      status { 'denied' }
    end

    trait :ended do
      approved
      start_date { 2.months.ago.monday }
      end_date { 1.day.ago }

      to_create { |instance| instance.save(validate: false) }
    end

    trait :ongoing do
      approved
      start_date { 1.day.ago.monday }
      end_date { 1.month.from_now }

      to_create { |instance| instance.save(validate: false) }
    end

    trait :scheduled do
      approved
      start_date { 1.week.from_now.monday }
      end_date { 1.month.from_now }
    end

    trait :expired do
      to_create { |instance| instance.save(validate: false) }
      pending
      start_date { 1.day.ago.monday }
      end_date { 1.month.from_now }
    end

    trait :valid do
      pending
      start_date { 1.week.from_now.monday }
      end_date { 1.month.from_now }
    end
  end
end
