require 'spec_helper'

feature "Admin Users", type: :feature, js: true do
  let(:admin_user) { FactoryBot.create(:super) }

  before do
    visit '/admin/'
    
    fill_in 'admin_user_email', with: admin_user.email
    fill_in 'admin_user_password', with: admin_user.password
    click_button 'Entrar'
  end

  scenario "admin user" do                                   
     expect(page).to have_content('Administradores')
    		                                                      
     fill_in 'q_email', with: admin_user.email
     click_button 'Filtrar'
     expect(page).to have_content(admin_user.email)
    
     visit '/admin/admin_users'
    
     fill_in 'q_email', with: "teste"
     click_button 'Filtrar'
     expect(page).to have_content("Nenhum(a) Administradores encontrado(a)")
     
     visit "/admin/admin_users/#{admin_user.id}"  
     
     expect(page).to have_content("Detalhes do(a) Administrador")

     visit "/admin/admin_users/#{admin_user.id}/edit"
     
     expect(page).to have_content("Editar Administrador")
  end
  
  scenario "new admin" do
     visit '/admin/admin_users/new'

     expect(page).to have_content("Novo(a) Administrador")
     
     click_button 'Criar Administrador'
     expect(page).to have_content("não pode ficar em branco")
  end
end
