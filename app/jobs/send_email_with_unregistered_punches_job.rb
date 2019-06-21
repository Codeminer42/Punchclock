class SendEmailWithUnregisteredPunchesJob < ApplicationJob
  queue_as :default

  def perform
    codeminer = Company.find_by(name: 'Codeminer42')

    codeminer.users.active.engineer.each do |user|
      initial_date = Date.current.prev_day(3).last_month
      final_date = Date.current.prev_day(4)
      work_days = (initial_date..final_date).select { |day| is_working_day?(day) }

      hash_work_days = work_days.map { |day| [day, 0] }.to_h
      hash_punches = user.punches.where("date(punches.from) in (?) and extra_hour = ?", work_days, false)
                                  .group("date(punches.from)").count

      unregistered_punches = hash_work_days.merge(hash_punches).select { |key, value| value < 2}

      unless unregistered_punches.empty?
        NotificationMailer.notify_unregistered_punches(user, unregistered_punches).deliver_now 
      end
    end
  end

  private

  def is_working_day?(day)
    day.on_weekday? && !day.holiday?(:br)
  end
end
