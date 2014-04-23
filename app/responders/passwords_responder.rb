class PasswordsResponder < ApplicationResponder
  def to_html
    if patch? then response_for_update else super end
  end

  protected

  def response_for_update
    unless has_errors? then password_changed! else password_not_changed! end
  end

  def password_changed!
    signin_and_notify!
    redirect_to(resource_location, notice: 'Password updated successfully!')
  end

  def signin_and_notify!
    controller.sign_in(resource, bypass: true)
    NotificationMailer.
      notify_user_password_change(resource, resource.password).deliver
  end

  def password_not_changed!
    controller.flash.now[:alert] = resource.errors.full_messages.first
    render action: :edit
  end
end
