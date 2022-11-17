FactoryBot.define do
  factory :vacation do
    start_date { 2.days.from_now }
    end_date { 2.months.from_now }
    status { 'pending' }
    user
    hr_approver { nil }
    project_manager_approver { nil }
    denier { nil }
  end
end
