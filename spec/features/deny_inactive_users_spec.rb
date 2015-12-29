require 'spec_helper'

feature 'Deny inactive users', focus: true do
  let(:user) { create(:user, active: false) }

  scenario 'on login' do
    login_as user, scope: :user
    visit "/"
    expect(page).to have_content "You are not authorized to access this page."
  end
end
