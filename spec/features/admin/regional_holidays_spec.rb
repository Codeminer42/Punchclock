# frozen_string_literal: true

require 'rails_helper'

describe "RegionalHolidays", type: :feature do
  let(:admin_user) { create(:user, :admin, occupation: :administrative) }

  before do
    create(:regional_holiday)
    sign_in(admin_user)
  end

  it 'index' do
    click_link 'Feriados regionais'

    expect(page).to have_content('Feriados regionais')
  end

  it 'view' do
    click_link 'Feriados regionais'
    click_link 'Visualizar'

    expect(page).to have_content('Detalhes do(a) Feriado regional')
  end

  it 'edit' do
    click_link 'Feriados regionais'
    click_link 'Editar'

    expect(page).to have_content('Editar Feriado regional')
  end

  it 'new Feriado regional' do
    click_link 'Feriados regionais'
    click_link 'Novo(a) Feriado regional'

    expect(page).to have_content('Novo(a) Feriado regional')

    click_button 'Criar Feriado regional'

    expect(page).to have_content("Feriado regional não pôde ser criado.")
  end
end
