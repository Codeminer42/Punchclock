require 'spec_helper'

feature "Punches", type: :feature do
  let(:admin_user) { FactoryBot.create(:super) }
  let!(:punch) { FactoryBot.create(:punch) }
  
  before do
    visit '/admin/'
    
    fill_in 'admin_user_email', with: admin_user.email
    fill_in 'admin_user_password', with: admin_user.password
    click_button 'Entrar'
  end

  scenario 'index' do 
     click_link 'Punches'
     expect(page).to have_content('Punches')
  end

  scenario 'filter' do
     click_link 'Punches'
     click_button 'Filtrar'

     expect(page).to have_content(punch.user.name)
  end
  
  scenario 'new punch' do
     click_link 'Punches'
     click_link 'Novo(a) Punch'

     expect(page).to have_content('Novo(a) Punch')
     
     click_button 'Criar Punch'
     expect(page).to have_content('não pode ficar em branco')
     
     fill_in 'punch_from', with: DateTime.now.to_date
     fill_in 'punch_to', with: DateTime.now.to_date
     click_button 'Criar Punch'	

     expect(page).to have_content('Punch foi criado com sucesso.')
  end
end
