# frozen_string_literal: true

require 'spec_helper'

feature "Admin Users", type: :feature do
  let(:admin_user) { create(:user, :admin, occupation: :administrative) }

  before do
    sign_in(admin_user)
    click_link 'Administradores'
  end

  scenario 'index' do
    expect(page).to have_content('Administradores')
  end

  scenario 'filter' do
    fill_in 'q_email', with: admin_user.email
    click_button 'Filtrar'

    expect(page).to have_content(admin_user.email)

    click_link 'Limpar Filtros'
    fill_in 'q_email', with: "teste"
    click_button 'Filtrar'

    expect(page).to have_content('Nenhum(a) Administradores encontrado(a)')
  end

  scenario 'view' do
    click_link 'Visualizar'

    expect(page).to have_content('Detalhes do(a) Administrador')
  end
end
