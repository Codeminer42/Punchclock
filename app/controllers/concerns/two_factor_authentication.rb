module TwoFactorAuthentication
  extend ActiveSupport::Concern

  def authenticate_otp
    @user = find_user

    if @user && @user.otp_required_for_login?
      if !user_params[:otp_attempt]
        prompt_two_factor(@user)
      elsif valid_otp?(@user)
        authenticate(@user)
      end
    end
  end

  private

  def prompt_two_factor(user)
    if @user.valid_password?(user_params[:password])
      session[:otp_user_id] = @user.id
      render 'devise/sessions/two_factor'
    end
  end

  def authenticate(user)
    session.delete(:otp_user_id)
    remember_me(user) if user_params[:remember_me]
    user.save!
    sign_in(@user, event: :authentication)
  end

  def valid_otp?(user)
    user.validate_and_consume_otp!(user_params[:otp_attempt]) ||
      user.invalidate_otp_backup_code!(user_params[:otp_attempt])
  end

  def find_user
    if user_params[:email]
      User.find_by(email: user_params[:email])
    elsif session[:otp_user_id]
      User.find(session[:otp_user_id])
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :remember_me, :otp_attempt)
  end
end
