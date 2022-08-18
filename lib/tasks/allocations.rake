namespace :allocations do
  desc 'Update users current allocation ongoing column'
  task update_users_current_allocation: :environment do
    ActiveRecord::Base.transaction do
      User.includes(:allocations).joins(:allocations).merge(Allocation.ongoing).each do |user|
        user.allocations.last.update(ongoing: true)
      end
    end
  end
end
