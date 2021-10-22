class NotificationMailer < ActionMailer::Base
  default from: 'do-not-reply@punchclock.com'

  def notify_admin_registration(admin_user)
    @user = admin_user
    mail(to: @user.email, subject: 'You were registered on Punchclock')
  end

  def notify_user_registration(user)
    @user = user
    @token = user.send(:set_reset_password_token)
    mail(to: @user.email, subject: 'Welcome to Punchclock')
  end

  def notify_user_password_change(user, new_password)
    @user = user
    @new_password = new_password
    mail(to: @user.email,
         subject: 'Punchclock - Your password has been modified')
  end

  def notify_admin_punches_pending(admin, user)
    @admin = admin
    @user = user
    mail(to: @admin.email, subject: "Punchclock - #{user.name} still inactive")
  end

  def notify_user_to_fill_punch(user)
    @user = user
    mail(to: @user.email, subject: "Preencher Punch")
  end

  def notify_admin_extra_hour(punches, admins_emails)
    @punches = punches
    mail(to: admins_emails, subject: "Punchclock - Horas extra registradas")
  end

  def notify_unregistered_punches(user, unregistered_punches)
    @unregistered_punches = unregistered_punches
    @user = user
    admin_email = ENV['ADMIN_EMAIL']
    mail(to: @user.email, bcc: admin_email, subject: "Punchclock - #{user.name} com Punches não cadastrados no sistema")
  end
end
