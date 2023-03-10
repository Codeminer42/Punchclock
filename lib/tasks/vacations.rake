namespace :vacations do
  desc "Cancel not approved expired vacations"
  task cancel_expired: :environment do
    Vacation.expired.each do |vacation|
      Rails.logger.info "Canceling #{vacation.user.name}'s expired vacation"
      vacation.status = :cancelled
      vacation.save(validate: false)
    end
  end

  desc "Send an e-mail as a reminder with the pending vacations to be approved"
  task alert_pending_approve: :environment do
    Rails.logger.info "Checking the pending vacations"

    hr_pending_approves = Vacation.pending_approval_of(:hr).all
    if hr_pending_approves.any?
      Rails.logger.info "Reminding HR of pending vacations"
      VacationMailer.notify_pending_vacations(User.hr, hr_pending_approves).deliver
    end

    commercial_pending_approves = Vacation.pending_approval_of(:commercial).all
    if commercial_pending_approves.any?
      Rails.logger.info "Reminding commercial of pending vacations"
      VacationMailer.notify_pending_vacations(User.commercial, commercial_pending_approves).deliver
    end
  end
end
