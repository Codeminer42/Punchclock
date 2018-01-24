require 'spec_helper'

feature "Company", type: :feature, js: true do
  let(:admin_user) { FactoryBot.create(:super) }
  let(:company) { FactoryBot.create(:company) }

  before do
    visit '/admin/'
 
    fill_in 'admin_user_email', with: admin_user.email
    fill_in 'admin_user_password', with: admin_user.password
    click_button 'Entrar'
  end
  
  scenario 'index' do
    click_link 'Empresas'
    expect(page).to have_content('Empresas')
    
    fill_in 'q_name', with: company.name
    click_button 'Filtrar'
    
    expect(page).to have_content(admin_user.email)

    fill_in 'q_name', with: "teste"
    click_button 'Filtrar'
    
    expect(page).to have_content('Nenhum(a) Empresas encontrado(a)')
    
    click_link 'Empresas'
    first('.odd').click_link('Visualizar')
    expect(page).to have_content('Detalhes do(a) Empresa')
    
    click_link 'Editar'

    expect(page).to have_content('Editar Empresa')
  end

  scenario 'new company' do
    click_link 'Empresas'
    click_link 'Novo(a) Empresa'

    expect(page).to have_content('Novo(a) Empresa')
     
    click_button 'Criar Empresa'

    expect(page).to have_content('Empresa foi criado com sucesso')
  end
end
