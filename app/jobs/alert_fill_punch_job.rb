class AlertFillPunchJob < ApplicationJob
  queue_as :default

  def perform(period)
    if period == "fifteen"
      day_fifteen_notification
    else
      end_of_month_notification
    end
  end

  private

  def day_fifteen_notification
    if is_working_day?
      User.engineer.active.find_each do |user|
        NotificationMailer.notify_user_to_fill_punch(user).deliver_later
      end

      User.admin.find_each do |admin|
        NotificationMailer.notify_user_to_fill_punch(admin).deliver_later
      end
    else
      AlertFillPunchJob.set(wait_until: 1.day.from_now).perform_later("fifteen")
    end
  end

  def end_of_month_notification
    last_day = last_business_day()

    if last_day.today?
      User.engineer.active.find_each do |user|
        NotificationMailer.notify_fill_punch_end_month(user).deliver_later
      end
    else
      AlertFillPunchJob.set(wait_until: last_day.noon).perform_later("end_month")
    end
  end

  def last_business_day(day = DateTime.current.end_of_month)
    if day.on_weekend?
      last_business_day(day.prev_weekday)
    else
      day
    end
  end

  def is_working_day?(day = Date.current)
    day.on_weekday? && !day.holiday?(:br)
  end
end
