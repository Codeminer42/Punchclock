namespace :vacations do
  desc "Cancel not approved expired vacations"
  task cancel_expired: :environment do
    Vacation.expired.each do |vacation|
      Rails.logger.info "Canceling #{vacation.user.name}'s expired vacation"
      vacation.status = :cancelled
      vacation.save(validate: false)
    end
  end

  desc "Send a e-mail as remember with the pending vacations to be approve"
  task alert_pending_approve: :environment do
    Rails.logger.info "anything"
    vacations = Vacation.pending

    hr_pending_approves = vacations.where(hr_approver_id: nil)
    if hr_pending_approves.any?
      Rails.logger.info "Remembering the HR of pending vacations"
      User.by_roles_in([:hr]).each do |hr_user|
        VacationMailer.notify_pending_vacations(hr_user, hr_pending_approves).deliver
      end
    end

    commercial_pending_approves = vacations.where(commercial_approver_id: nil)
    if commercial_pending_approves.any?
      Rails.logger.info "Remembering the commercial of pending vacations"
      User.by_roles_in([:commercial]).each do |commercial_user|
        VacationMailer.notify_pending_vacations(commercial_user, commercial_pending_approves).deliver
      end
    end
  end
end
