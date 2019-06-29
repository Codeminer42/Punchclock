# frozen_string_literal: true

require 'spec_helper'

feature "Admin Users", type: :feature do
  let(:admin_user) { FactoryBot.create(:super) }
  let!(:company) { FactoryBot.create(:company) }
  before do
    visit '/admin/'

    fill_in 'admin_user_email', with: admin_user.email
    fill_in 'admin_user_password', with: admin_user.password
    click_button 'Entrar'
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

  scenario 'edit' do
    click_link  'Editar'

    expect(page).to have_content('Editar Administrador')
  end

  scenario 'new admin' do
    click_link 'Novo(a) Administrador'

    expect(page).to have_content('Novo(a) Administrador')

    click_button 'Criar Administrador'

    expect(page).to have_content('não pode ficar em branco')

    fill_in 'admin_user_email', with: 'teste@hotmail.com'
    fill_in 'admin_user_password', with:  'password'
    fill_in 'admin_user_password_confirmation', with:'password'
    select company.name, from: 'admin_user_company_id'
    click_button 'Criar Administrador'

    expect(page).to have_content('Administrador foi criado com sucesso.')
  end
end
