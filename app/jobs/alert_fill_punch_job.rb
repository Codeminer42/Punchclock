class AlertFillPunchJob < ActiveJob::Base
  include Sidekiq
  queue_as :default

  def perform
    Company.all.find_each do |company|
      admins = company.users.active.is_admin

      company.users.active.find_each do |user|
        NotificationMailer.notify_user_to_fill_punch(user).deliver_now
      end
    end
  end

end
