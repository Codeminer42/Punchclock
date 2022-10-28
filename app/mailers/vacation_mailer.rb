class VacationMailer < ApplicationMailer
  def notify_vacation_request(vacation, admins_emails)
    @vacation = vacation
    mail(to: admins_emails, subject: "Punchclock - #{@vacation.user.name} is requesting vacations")
  end
end
