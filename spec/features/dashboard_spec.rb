# frozen_string_literal: true

require 'rails_helper'

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

    find('td.inner', text: '10').click
    find('td.inner', text: '11').click
    click_on 'Salvar'
    expect(page).to have_no_content("Selecionado")

    visit '/dashboard/2013/10'
    find('td.inner', text: '15').click
    find('a', text: 'Apagar').click
    expect(page).to have_no_content("Selecionado")
  end

  scenario 'Multiple selection through sheets' do
    visit '/dashboard/2018/02'

    find('td.inner', text: '14').click
    find('td.inner', text: '15').click
    expect(page).to have_content('Selecionado (2)')
    find('a', text: '❯').click
    expect(page).to have_content('Selecionado (2)')

    within 'tbody > tr:nth-child(1)' do
      expect(page).to have_css("td.selected", text: "14") & have_css("td.selected", text: "15")
    end

    find('td.inner', text: '16').click
    expect(page).to have_content('Selecionado (3)')
    click_on 'Salvar'
    expect(page).to have_content('Horas: 24')
  end
end
