class SendEmailWithExtraHourJob queue_as :default
  def perform
  codeminer = Company.find_by(name: "Codeminer42")
  admins_emails = codeminer.users.admin.active.pluck(:email)

  extra_hour_punches = codeminer.punches
    .is_extra_hour
    .from_last_month
    .group_by(&:user_name).to_a

  NotificationMailer.notify_admin_extra_hour(extra_hour_punches, admins_emails).deliver_later unless extra_hour_punches.empty?
end end
