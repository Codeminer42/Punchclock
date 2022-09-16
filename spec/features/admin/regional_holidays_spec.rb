# frozen_string_literal: true

require 'spec_helper'

feature "RegionalHolidays", type: :feature do
  let(:admin_user) { create(:user, :admin, occupation: :administrative) }

  background do
    create(:regional_holiday)
    sign_in(admin_user)
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
