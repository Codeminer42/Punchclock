require 'spec_helper'

feature "Punches", type: :feature, js: true do
  let(:admin_user) { FactoryBot.create(:super) }
  let(:punch) { FactoryBot.create(:punch) }
  
  before do
    visit '/admin/punches'
    
    fill_in 'admin_user_email', with: admin_user.email
    fill_in 'admin_user_password', with: admin_user.password
    click_button 'Entrar'
  end

  scenario "Punches" do 
     expect(page).to have_content('Punches')
    		                                                      
     click_button 'Filtrar'
     expect(page).to have_content("Não existem Punches ainda")
    
     visit "/admin/punches/#{punch.id}"  
     
     expect(page).to have_content("Detalhes do(a) Punch")

     visit "/admin/punches/#{punch.id}/edit"
     
     expect(page).to have_content("Editar Punch")
  end
  
  scenario "New punch" do
     visit '/admin/punches/new'

     expect(page).to have_content("Novo(a) Punch")
     
     click_button 'Criar Punch'
     expect(page).to have_content("não pode ficar em branco")
  end
end
