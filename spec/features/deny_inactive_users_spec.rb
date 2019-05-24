# frozen_string_literal: true

require 'rails_helper'

describe "Deny inactive users", type: :feature do
  let(:user) { create(:user, active: false, password: 'asdfasdf') }

  scenario 'on login' do
    visit "/"
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'asdfasdf'
    click_on 'Sign In'
    expect(page).to have_content "Conta desativada"
  end
end
