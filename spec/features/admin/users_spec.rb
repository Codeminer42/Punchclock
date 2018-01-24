require 'spec_helper'

feature "Users", type: :feature, js: true do
  let(:admin_user) { FactoryBot.create(:super) }
  let(:user) { FactoryBot.create(:user) }
  
  before do
    visit '/admin/users'
    
    fill_in 'admin_user_email', with: admin_user.email
    fill_in 'admin_user_password', with: admin_user.password
    click_button 'Entrar'
  end

  scenario "Usuários" do 
     expect(page).to have_content('Usuários')
    	
     fill_in 'q_name', with: user.name
     click_button 'Filtrar'
     expect(page).to have_content(user.name)
    
     fill_in 'q_name', with: "teste"
     click_button 'Filtrar'
     expect(page).to have_content('Nenhum(a) Usuários encontrado(a)')

     visit "/admin/users/#{user.id}"  
     
     expect(page).to have_content("Detalhes do(a) Usuário")

     visit "/admin/users/#{user.id}/edit"
     
     expect(page).to have_content("Editar Usuário")
  end
  
  scenario "New User" do
     visit '/admin/users/new'

     expect(page).to have_content("Novo(a) Usuário")
     
     click_button 'Criar Usuário'
     expect(page).to have_content("não pode ficar em branco")
  end
end
