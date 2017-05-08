class AlertFillPunchJob < ActiveJob::Base
  queue_as :default

  def perform
    User.active.find_each do |user|
      NotificationMailer.notify_user_to_fill_punch(user).deliver_now
    end
  end

end
