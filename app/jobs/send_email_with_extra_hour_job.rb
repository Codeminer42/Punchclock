class SendEmailWithExtraHourJob < ActiveJob::Base
  queue_as :default
  MAX_ALLOWED_HOURS = 8

  def perform
    today = Time.zone.yesterday
    one_month_ago = (today.prev_month + 1.day)

    User.active.each do |user|
      dates = []
      (one_month_ago.to_date..today.to_date).each do |date|
        punches = user.punches.by_days(date)

        worked_hours = punches.inject(0) {|sum, punch| sum + (punch.to - punch.from) }

        dates << date.strftime("%d/%m/%Y") if (worked_hours/60/60).abs > MAX_ALLOWED_HOURS
      end

      if dates.present?
        User.admin.each do |admin|
          NotificationMailer.notify_admin_extra_hour(admin, user, dates)
        end
      end
    end
  end
end
