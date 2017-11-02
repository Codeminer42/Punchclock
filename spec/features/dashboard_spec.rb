require 'spec_helper'

feature 'Punches Dashboard', js: true do
  let!(:authed_user) { create_logged_in_user }

  scenario 'Calendar navigation' do
    visit '/dashboard/2014/12'

    expect(page).to have_content('Nov / Dec 2014')
    find('a', text: '❯').click
    expect(page).to have_content('Dec 2014 / Jan 2015')
    find('a', text: '❮').click
    expect(page).to have_content('Nov / Dec 2014')
  end

  scenario 'Insert and delete punches' do
    visit '/dashboard/2013/10'

    find('td.inner', text: '17').click
    find('td.inner', text: '18').click
    click_on 'Ok'
    expect(page).to have_content('Alterações (2)')
    click_on 'Salvar'
    expect(page).to have_no_content('Alterações (2)')

    visit '/dashboard/2013/10'
    find('td.inner', text: '17').click
    find('a', text: 'Apagar').click
    expect(page).to have_content('Alterações (1)')
    click_on 'Salvar'
    expect(page).to have_no_content('Alterações (1)')
  end
end
