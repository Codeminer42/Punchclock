class VacationMailer < ApplicationMailer
  HR_EMAIL = ENV.fetch("HR_EMAIL")

  def notify_vacation_request(vacation, admins_emails)
    @vacation = vacation
    mail(to: admins_emails, cc: HR_EMAIL,  subject: t('.subject', user: @vacation.user.name))
  end

  def notify_vacation_approved(vacation)
    @vacation = vacation
    mail(to: vacation.user.email, cc: HR_EMAIL )
  end

  def admin_vacation_approved(vacation)
    @vacation = vacation
    mail(to: HR_EMAIL, subject: t('.subject', user: @vacation.user.name))
  end

  def notify_vacation_denied(vacation)
    @vacation = vacation
    mail(to: vacation.user.email, cc: HR_EMAIL )
  end

  def notify_vacation_cancelled(vacation)
    @vacation = vacation
    mail(to: User.vacation_managers.pluck(:email), cc: ENV['HR_EMAIL'], subject: t('.subject', user: @vacation.user.name))
  end

  def notify_pending_vacations(user, vacations)
    @vacations = vacations
    mail(to: user.email, subject: t('.subject'))
  end
end
