# frozen_string_literal: true

require 'spec_helper'

feature "RegionalHolidays", type: :feature do
  let(:admin_user) { create(:super) }

  background do
    create(:regional_holiday)
    visit '/admin/'

    fill_in 'admin_user_email', with: admin_user.email
    fill_in 'admin_user_password', with: admin_user.password

    click_button 'Entrar'
  end

  scenario 'index' do
    click_link 'Feriados regionais'

    expect(page).to have_content('Feriados regionais')
  end

  scenario 'view' do
    click_link 'Feriados regionais'
    click_link 'Visualizar'

    expect(page).to have_content('Detalhes do(a) Feriado regional')
  end

  scenario 'edit' do
    click_link 'Feriados regionais'
    click_link 'Editar'

    expect(page).to have_content('Editar Feriado regional')
  end

  scenario 'new Feriado regional' do
    click_link 'Feriados regionais'
    click_link 'Novo(a) Feriado regional'

    expect(page).to have_content('Novo(a) Feriado regional')

    click_button 'Criar Feriado regional'

    expect(page).to have_content("Feriado regional não pôde ser criado.")
  end
end
