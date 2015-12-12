class PasswordsResponder < ApplicationResponder
  def to_html
    patch? ? response_for_update : super
  end

  protected

  def response_for_update
    has_errors? ? password_not_changed! : password_changed!
  end

  def password_changed!
    signin_and_notify!
    redirect_to(resource_location, notice: 'Password updated successfully!')
  end

  def signin_and_notify!
    controller.sign_in(resource, bypass: true)
    NotificationMailer.
      notify_user_password_change(resource, resource.password).deliver_now
  end

  def password_not_changed!
    controller.flash.now[:alert] = resource.errors.full_messages.first
    render action: :edit
  end
end
