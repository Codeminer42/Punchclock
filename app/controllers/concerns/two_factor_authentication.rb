module TwoFactorAuthentication
  extend ActiveSupport::Concern

  def authenticate_otp
    VerifyUserAuthenticity.call(**verify_user_authenticity_params) do |result|
      @user = result.user

      return unless result.otp_required_for_login?
      return assign_session_and_redirect(@user) if result.authenticate?

      authenticate(@user) if result.valid_otp?
    end
  end

  private

  def assign_session_and_redirect(user)
    session[:otp_user_id] = user.id

    render 'devise/sessions/two_factor'
  end

  def authenticate(user)
    session.delete(:otp_user_id)

    remember_me(user) if user_params[:remember_me]

    sign_in(user, event: :authentication)
  end

  def verify_user_authenticity_params
    {
      email: user_params[:email],
      password: user_params[:password],
      user_id: session[:otp_user_id],
      otp_attempt: user_params[:otp_attempt]
    }
  end

  def user_params
    params.require(:user).permit(:email, :password, :remember_me, :otp_attempt)
  end
end
