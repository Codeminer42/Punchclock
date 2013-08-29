class NotificationMailer < ActionMailer::Base
  default from: "do-not-reply@punchclock.com"

  def notify_user_registration(user)
  	@user = user
  	mail(to:user.email, subject:"Welcome to Punchclock")
  end
end
