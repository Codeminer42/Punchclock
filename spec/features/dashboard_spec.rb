require 'spec_helper'

feature 'Punches list', js: true do
  let!(:authed_user) { create_logged_in_user }

  before do
    visit '/dashboard/2014/12'
  end

  scenario do
    expect(page).to have_content('Nov / Dez 2014')
  end
end

