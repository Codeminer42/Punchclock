# frozen_string_literal: true

module IntegrationHelpers
  def sign_in(user, otp: nil)
    visit root_path

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password

    if user.otp_required_for_login
      fill_in 'user_otp_attempt', with: (otp || user.current_otp)
    end

    click_button 'Login'
  end
end
