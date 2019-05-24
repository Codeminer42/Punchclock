# frozen_string_literal: true

module IntegrationHelpers
  def admin_sign_in(user)
    visit '/admin'

    fill_in 'admin_user_email', with: user.email
    fill_in 'admin_user_password', with: user.password

    click_button 'Entrar'
  end
end
