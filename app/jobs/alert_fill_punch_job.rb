class AlertFillPunchJob < ApplicationJob
  queue_as :default

  def perform
    codeminer = Company.find_by name: "Codeminer42"
    codeminer.users.active.find_each do |user|
      NotificationMailer.notify_user_to_fill_punch(user).deliver_later
    end

    codeminer.admin_users.find_each do |admin|
      NotificationMailer.notify_user_to_fill_punch(admin).deliver_later
    end
  end
end
