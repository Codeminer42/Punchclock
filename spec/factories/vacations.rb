FactoryBot.define do
  factory :vacation do
    start_date { Date.today }
    end_date { 2.months.from_now }
    status { 'pending' }
    user
    commercial_approver { nil }
    administrative_approver { nil }
  end
end
