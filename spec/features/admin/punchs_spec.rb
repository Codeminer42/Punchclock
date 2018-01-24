require 'spec_helper'

feature "Punches", type: :feature, js: true do
  let(:admin_user) { FactoryBot.create(:super) }
  let(:punch) { FactoryBot.create(:punch) }
  
  before do
    visit '/admin/'
    
    fill_in 'admin_user_email', with: admin_user.email
    fill_in 'admin_user_password', with: admin_user.password
    click_button 'Entrar'
  end

  scenario 'index' do 
     click_link 'Punches'
     expect(page).to have_content('Punches')
    		                                                      
     click_button 'Filtrar'
     expect(page).to have_content('Não existem Punches ainda')
  end
  
  scenario 'new punch' do
     click_link 'Punches'
     click_link 'Novo(a) Punch'

     expect(page).to have_content('Novo(a) Punch')
     
     click_button 'Criar Punch'
     expect(page).to have_content('não pode ficar em branco')
  end
end
