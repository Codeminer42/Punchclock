require 'spec_helper'

feature "Project", type: :feature do
  let(:admin_user) { FactoryBot.create(:super) }
  let!(:project) { FactoryBot.create(:project) }
  let!(:company) { FactoryBot.create(:company) }

  before do
    visit '/admin/'

    fill_in 'admin_user_email', with: admin_user.email
    fill_in 'admin_user_password', with: admin_user.password
    click_button 'Entrar'
  end

  scenario 'index' do
    click_link 'Projetos'

    expect(page).to have_content('Projetos')
  end

  scenario 'filter' do
    click_link 'Projetos'
    fill_in 'q_name', with: project.name
    click_button 'Filtrar'

    expect(page).to have_content(project.name)

    fill_in 'q_name', with: 'teste'
    click_button 'Filtrar'

    expect(page).to have_content('Nenhum(a) Projetos encontrado(a)')
  end

  scenario 'view' do
    click_link 'Projetos'
    click_link 'Visualizar'

    expect(page).to have_content('Detalhes do(a) Projeto')
  end

  scenario 'edit' do
    click_link 'Projetos'
    click_link 'Editar'

    expect(page).to have_content('Editar Projeto')
  end

  scenario 'new project' do
    click_link 'Projetos'
    click_link 'Novo(a) Projeto'

    expect(page).to have_content('Novo(a) Projeto')

    click_button 'Criar Projeto'
    expect(page).to have_content('não pode ficar em branco')
	
    fill_in 'project_name', with: 'Nome Projeto'
    click_button 'Criar Projeto'

    expect(page).to have_content('é obrigatório')

    select(company.name, from: 'project_company_id').select_option
    click_button 'Criar Projeto'

    expect(page).to have_content('Projeto foi criado com sucesso.')
  end
end
