class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def edit
  end

  def update
    current_user.attributes = user_params
    if current_user.save
      redirect_to root_path, notice: "User updated"
    else
      render :edit
    end
  end

  def two_factor
    if current_user.otp_secret.blank?
      current_user.otp_secret = User.generate_otp_secret
      current_user.save!
    end

    @image_data = QrCodeGeneratorService.call(current_user)
  end

  def confirm_otp
    otp_attempt = params[:otp_attempt]

    if validate_otp(otp_attempt)
      enable_two_factor
      redirect_to backup_codes_path, notice: t('2fa_enabled')
    else
      redirect_to two_factor_path, alert: t('otp_fail')
    end
  end

  def backup_codes
    @codes = current_user.generate_otp_backup_codes!
    current_user.save!
  end

  private

  def validate_otp(otp_attempt)
    otp_attempt == current_user.current_otp
  end

  def enable_two_factor
    current_user.otp_required_for_login = true
    current_user.save!
  end
  
  def user_params
    params.require(:user).permit(:name, :email)
  end
end
