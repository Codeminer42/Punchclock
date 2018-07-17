class SendEmailWithExtraHourJob < ApplicationJob
  queue_as :default

  def perform
    codeminer = Company.find_by(name: "Codeminer42")
    admins = codeminer.admin_users
    extra_hour_punches = codeminer.punches
      .is_extra_hour
      .from_last_month
      .group_by(&:user_name).to_a

    NotificationMailer.notify_admin_extra_hour(extra_hour_punches, admins).deliver_later unless extra_hour_punches.empty?
  end
end
