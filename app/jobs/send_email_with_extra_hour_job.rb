class SendEmailWithExtraHourJob < ApplicationJob
  queue_as :default

  def perform
    admins_emails = User.admin.active.pluck(:email)

    extra_hour_punches = Punch
      .is_extra_hour
      .from_last_month
      .group_by(&:user_name).to_a

    NotificationMailer.notify_admin_extra_hour(extra_hour_punches, admins_emails).deliver_later unless extra_hour_punches.empty?
  end
end
