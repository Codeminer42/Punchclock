class AlertFillPunchJob < ApplicationJob
  queue_as :default

  def perform
    if is_working_day?
      codeminer = Company.find_by name: "Codeminer42"
      codeminer.users.engineer.active.find_each do |user|
        NotificationMailer.notify_user_to_fill_punch(user).deliver_later
      end

      codeminer.users.admin.find_each do |admin|
        NotificationMailer.notify_user_to_fill_punch(admin).deliver_later
      end
    else
      AlertFillPunchJob.set(wait_until: 1.day.from_now).perform_later
    end
  end

  private

  def is_working_day?(day = Date.current)
    day.on_weekday? && !day.holiday?(:br)
  end
end
