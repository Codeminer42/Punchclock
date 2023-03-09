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
    vacations = Vacation.pending

    hr_pending_approves = vacations.where(hr_approver_id: nil)
    if hr_pending_approves.any?
      Rails.logger.info "Remembering the HR of pending vacations"
      VacationMailer.notify_pending_vacations(User.hr, hr_pending_approves).deliver
    end

    commercial_pending_approves = vacations.where(commercial_approver_id: nil)
    if commercial_pending_approves.any?
      Rails.logger.info "Remembering the commercial of pending vacations"
      VacationMailer.notify_pending_vacations(User.commercial, commercial_pending_approves).deliver
      end
    end
  end
end
