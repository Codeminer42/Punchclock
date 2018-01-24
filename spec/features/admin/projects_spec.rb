require 'spec_helper'

feature "Project", type: :feature, js: true do
  let(:admin_user) { FactoryBot.create(:super) }
  let(:project) { FactoryBot.create(:project) }
  
  before do
    visit '/admin/projects'
    
    fill_in 'admin_user_email', with: admin_user.email
    fill_in 'admin_user_password', with: admin_user.password
    click_button 'Entrar'
  end

  scenario "projects" do                                   
     expect(page).to have_content('Projetos')
    		                                                      
     fill_in 'q_name', with: project.name
     click_button 'Filtrar'
     expect(page).to have_content(project.name)
    
     visit '/admin/projects'
    
     fill_in 'q_name', with: "teste"
     click_button 'Filtrar'
     expect(page).to have_content("Nenhum(a) Projetos encontrado(a)")
     
     visit "/admin/projects/#{project.id}"  
     
     expect(page).to have_content("Detalhes do(a) Projeto")

     visit "/admin/projects/#{project.id}/edit"
     
     expect(page).to have_content("Editar Projeto")
  end
  
  scenario "New project" do
     visit '/admin/projects/new'

     expect(page).to have_content("Novo(a) Projeto")
     
     click_button 'Criar Projeto'
     expect(page).to have_content("não pode ficar em branco")
  end
end
