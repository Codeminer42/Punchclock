require 'spec_helper'

feature "Users", type: :feature do
  let(:admin_user) { FactoryBot.create(:super) }
  let!(:user) { FactoryBot.create(:user) }
  let!(:company) { FactoryBot.create(:company) }

  before do
    visit '/admin/'

    fill_in 'admin_user_email', with: admin_user.email
    fill_in 'admin_user_password', with: admin_user.password
    click_button 'Entrar'
  end

  scenario 'index' do 
    click_link 'Usuários'

    expect(page).to have_content('Usuários')
  end

  scenario 'filter' do
    click_link 'Usuários'
    fill_in 'q_name', with: user.name
    click_button 'Filtrar'

    expect(page).to have_content(user.name)

    fill_in 'q_name', with: 'teste'
    click_button 'Filtrar'

    expect(page).to have_content('Nenhum(a) Usuários encontrado(a)')
  end

  scenario 'view' do
    click_link 'Usuários'
    click_link 'Visualizar'  

    expect(page).to have_content('Detalhes do(a) Usuário')
  end

  scenario 'edit' do
    click_link 'Usuários'
    click_link 'Editar'

    expect(page).to have_content('Editar Usuário')
  end

  scenario 'new User' do
    click_link 'Usuários'
    click_link 'Novo(a) Usuário'

    expect(page).to have_content('Novo(a) Usuário')

    click_button 'Criar Usuário'
    expect(page).to have_content('não pode ficar em branco')

    fill_in 'user_name', with: 'user'
    fill_in 'user_email', with: 'teste2@hotmail.com'
    fill_in 'user_password', with: 'password'
    select(company.name, from: 'user_company_id').select_option

    click_button 'Criar Usuário'

    expect(page).to have_content('Usuário foi criado com sucesso.')
  end
end
