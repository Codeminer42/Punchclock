class AlertSendEmailJob < ActiveJob::Base
  queue_as :default

  def perform(starts_at, ends_at)

    Company.all.each do |company|
      admins = company.users.is_admin

      company.users.active.find_each do |user|
        dates = []
        (starts_at.to_date..ends_at.to_date).to_a.each do |date|

          punches = user.punches.by_day(date)

          hour = []
          punches.each do |punch|
            hour.push(delta_time(punch.to, punch.from))

            if hour.sum > 8
              dates.push(date.to_s)
            end
          end

        end
        unless dates.empty?
          admins.each do |admin|
            # NotificationMailer.notify_admin_extra_hour(admin, user, dates)
          end
        end
      end
    end
  end

  private

    def return_hour(date)
      date.strftime('%H:%M').to_i
    end

    def delta_time(to, from)
      return_hour(to) - return_hour(from)
    end
end
