class VacationMailer < ApplicationMailer
  def notify_vacation_request(vacation, admins_emails)
    @vacation = vacation
    mail(to: admins_emails, subject: t('.subject', user: @vacation.user.name))
  end

  def notify_vacation_approved(vacation)
    @vacation = vacation
    mail(to: vacation.user.email)
  end

  def notify_vacation_denied(vacation)
    @vacation = vacation
    mail(to: vacation.user.email)
  end
end
