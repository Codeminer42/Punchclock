class SendEmailWithExtraHourJob < ApplicationJob
  queue_as :default

  def perform
    current_month = Date.current.change(day: 15)
    last_month = current_month.prev_month + 1.day

    codeminer = Company.find_by(name: "Codeminer42")
    admins = codeminer.admin_users
    extra_hour_punches = codeminer.punches
      .where.not(extra_hour: [nil, ""])
      .where(from: last_month..current_month)
      .group_by(&:user_name).to_a

    NotificationMailer.notify_admin_extra_hour(extra_hour_punches, admins).deliver_later unless extra_hour_punches.empty?
  end
end
