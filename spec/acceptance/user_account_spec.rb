require 'spec_helper'

feature "User Account" do
  let!(:authed_user) { create_logged_in_user }

  before do
    visit edit_user_path(authed_user)
    expect(page).to have_selector('.btn-danger[href="/punches"]')
    expect(page).to have_selector(".btn-default[href=\"#{users_account_password_edit_path}\"]")
    expect(page).to have_field( 'user_name', with: authed_user.name)
    expect(page).to have_field( 'user_email', with: authed_user.email)
  end

  scenario "update data" do
    within '.edit_user' do
      fill_in 'user[name]', with: 'Employer Test'
      fill_in 'user[email]', with: 'employer@test.ts'
      click_button 'Update'
    end
    expect(page).to have_content('User updated successfully!')
    expect(page).to have_field( 'user_name', with: 'Employer Test')
    expect(page).to have_field( 'user_email', with: 'employer@test.ts')
  end

  scenario "update password" do
    click_link 'Change Password'
    expect(page).to have_selector(".btn-danger[href=\"#{edit_user_path(authed_user)}\"]")
    within '.edit_user' do
      fill_in 'user[current_password]', with: authed_user.password
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
      click_button 'Update'
    end
    expect(page).to have_content('Password updated successfully!')
  end
end
