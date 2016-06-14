require 'spec_helper'

feature 'Deny inactive users' do
  let(:user) { create(:user, active: false, password: 'asdfasdf') }

  scenario 'on login' do
    visit "/"
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'asdfasdf'
    click_on 'Sign In'
    expect(page).to have_content "E-mail ou senha inválidos"
  end
end
