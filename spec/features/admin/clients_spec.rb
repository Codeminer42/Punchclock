require 'spec_helper'

feature "Clients", type: :feature, js: true do
  let(:admin_user) { FactoryBot.create(:super) }
  let(:client) { FactoryBot.create(:client) }

  before do 
    visit '/admin/clients'
    
    fill_in 'admin_user_email', with: admin_user.email               
    fill_in 'admin_user_password', with: admin_user.password
    click_button 'Entrar'
  end

  scenario "clients" do      
    expect(page).to have_content('Clientes')
    
    fill_in 'q_name', with: client.name
    click_button 'Filtrar'
    
    expect(page).to have_content(client.name)
    visit '/admin/clients'
    
    fill_in 'q_name', with: "teste"
    click_button 'Filtrar'
    
    expect(page).to have_content("Nenhum(a) Clientes encontrado(a)")
    
    visit "/admin/clients/#{client.id}"  
    
    expect(page).to have_content("Detalhes do(a) Cliente")
    
    visit "/admin/clients/#{client.id}/edit"
    
    expect(page).to have_content("Editar Cliente")
  end
 
  scenario "New client" do
    visit '/admin/clients/new'

    expect(page).to have_content("Novo(a) Cliente")
     
    click_button 'Criar te'

    expect(page).to have_content("não pode ficar em branco")
  end
end
