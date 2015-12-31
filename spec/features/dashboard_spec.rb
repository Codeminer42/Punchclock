require 'spec_helper'

feature 'Punches Dashboard', js: true do
  let!(:authed_user) { create_logged_in_user }

  scenario 'Calendar navigation' do
    visit '/dashboard/2014/12'

    expect(page).to have_content('Nov / Dez 2014')
    find('a', text: '❯').click
    expect(page).to have_content('Dez 2014 / Jan 2015')
    find('a', text: '❮').click
    expect(page).to have_content('Nov / Dez 2014')
  end
end

