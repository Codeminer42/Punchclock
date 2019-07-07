# frozen_string_literal: true

module IntegrationHelpers
  def sign_in(user)
    visit root_path

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password

    click_button 'Sign In'
  end
end
