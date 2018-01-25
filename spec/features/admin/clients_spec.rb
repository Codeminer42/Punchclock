require 'spec_helper'

feature 'Clients', type: :feature do
  let(:admin_user) { FactoryBot.create(:super) }
  let!(:client) { FactoryBot.create(:client) }

  before do 
    visit '/admin'
    
    fill_in 'admin_user_email', with: admin_user.email               
    fill_in 'admin_user_password', with: admin_user.password
    click_button 'Entrar'
  end

  scenario 'index' do      
    click_link 'Clientes'

    expect(page).to have_content('Clientes')
  end

  scenario 'filter' do
    click_link 'Clientes'
    fill_in 'q_name', with: client.name
    click_button 'Filtrar'
    
    expect(page).to have_content(client.name)
    
    fill_in 'q_name', with: "teste"
    click_button 'Filtrar'
    
    expect(page).to have_content('Nenhum(a) Clientes encontrado(a)')
  end

  scenario 'view' do
    click_link 'Clientes'
    click_link 'Visualizar'  
    
    expect(page).to have_content('Detalhes do(a) Cliente')
  end

  scenario 'edit' do
    click_link 'Clientes'
    click_link 'Editar'
    
    expect(page).to have_content('Editar Cliente')
  end
 
  scenario 'new client' do
    click_link 'Clientes'
    click_link 'Novo(a) Cliente'

    expect(page).to have_content('Novo(a) Cliente')
     
    click_button 'Criar Cliente'

   expect(page).to have_content('não pode ficar em branco')

   fill_in 'client_name', with: 'Joao'
   click_button 'Criar Cliente'

   expect(page).to have_content('Cliente foi criado com sucesso.')
 
  end
end
