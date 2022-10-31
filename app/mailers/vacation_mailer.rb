class VacationMailer < ApplicationMailer
  def notify_vacation_request(vacation, admins_emails)
    @vacation = vacation
    mail(to: admins_emails, subject: (t '.subject', user: @vacation.user.name))
  end
end
