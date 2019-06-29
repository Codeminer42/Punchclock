class NotifyUnregisteredPunchesJob < ApplicationJob
  queue_as :default

  def perform
    codeminer = Company.find_by(name: 'Codeminer42')

    codeminer.users.employee.engineer.active.each do |user|
      final_date = Date.current.change(day: 15)
      initial_date = final_date.prev_month.change(day: 16)

      work_days = (initial_date..final_date).select { |day| working_day?(day) }

      work_days_punches_count = work_days.product([0]).to_h
      punches_by_day = user.punches.where("date(punches.from) in (?) and extra_hour = ?", work_days, false)
                                  .group("date(punches.from)").count

      unregistered_punches = work_days_punches_count.merge(punches_by_day).select { |key, value| value < 2}

      unless unregistered_punches.empty?
        NotificationMailer.notify_unregistered_punches(user, unregistered_punches).deliver_later
      end
    end
  end

  private

  def working_day?(day)
    day.on_weekday? && !day.holiday?(:br)
  end
end
