class NotificationMailer < ActionMailer::Base
  default from: "do-not-reply@punchclock.com"

  def notify_admin_registration(admin_user)
    @user = admin_user
    mail(to:@user.email, subject:"You was registered on Punchclock")
  end

  def notify_user_registration(user)
  	@user = user
  	mail(to:@user.email, subject:"Welcome to Punchclock")
  end

  def notify_user_password_change(user, new_password)
  	@user = user
  	@new_password = new_password
  	mail(to:@user.email, subject:"Punchclock - Your password has been modified")
  end
end
