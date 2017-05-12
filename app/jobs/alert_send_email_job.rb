class AlertSendEmailJob < ActiveJob::Base
  queue_as :default

  def perform
    today = Time.zone.now
    one_month_ago = today.prev_month - 1.day

    User.active.find_each do |user|
      dates = []
      (one_month_ago.to_date..today.to_date).each do |date|
        punches = user.punches.by_day(date)

        worked_hours = punches.inject(0) {|sum, punch| sum + (punch.to - punch.from) }

        dates << date.to_s if (worked_hours/60/60).abs > 8
      end
      if dates
        User.is_admin.each do |admin|
          NotificationMailer.notify_admin_extra_hour(admin, user, dates)
        end
      end
    end
  end
end
