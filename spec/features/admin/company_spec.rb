require 'spec_helper'

feature "Company", type: :feature, js: true do
  let(:admin_user) { FactoryBot.create(:super) }
  let(:company) { FactoryBot.create(:company) }

  before do
    visit '/admin/companies'
 
    fill_in 'admin_user_email', with: admin_user.email
    fill_in 'admin_user_password', with: admin_user.password
    click_button 'Entrar'
  end
  
  scenario "Company" do                   
    expect(page).to have_content('Empresas')
    
    fill_in 'q_name', with: company.name
    click_button 'Filtrar'
    
    expect(page).to have_content(admin_user.email)
    
    visit '/admin/companies'
    
    fill_in 'q_name', with: "teste"
    click_button 'Filtrar'
    
    expect(page).to have_content("Nenhum(a) Empresas encontrado(a)")
    
    visit "/admin/companies/#{company.id}"  
    
    expect(page).to have_content("Detalhes do(a) Empresa")
    
    visit "/admin/companies/#{company.id}/edit"									        
    expect(page).to have_content("Editar Empresa")
  end

  scenario "New company" do
    visit '/admin/companies/new'

    expect(page).to have_content("Novo(a) Empresa")
     
    click_button 'Criar Empresa'

    expect(page).to have_content("Empresa foi criado com sucesso")
  end
end
