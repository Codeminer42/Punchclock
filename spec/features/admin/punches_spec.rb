require 'spec_helper'

feature "Punches with super admin_user", type: :feature do
  let(:admin_user) { create :super }
  let!(:punch) { create :punch }
  let!(:user) { create :user }
  let(:company) { user.company }
  let!(:project) { create :project }

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

    select(user.name, from: 'punch_user_id').select_option
    select(project.name, from: 'punch_project_id').select_option
    select(company.name, from: 'punch_company_id').select_option
    fill_in 'punch_from', with: DateTime.now.to_date
    fill_in 'punch_to', with: DateTime.now.to_date
    click_button 'Criar Punch'

    expect(page).to have_content('Punch foi criado com sucesso.')
  end
end

feature "Punches with normal admin_user", type: :feature do
  let(:admin_user) { create :admin_user }
  let!(:punch) { create :punch, company_id: admin_user.company_id }

  before do
    visit '/admin/'

    fill_in 'admin_user_email', with: admin_user.email
    fill_in 'admin_user_password', with: admin_user.password
    click_button 'Entrar'
  end

  scenario 'index' do
    click_link 'Punches'
    expect(page).to have_content('Punches') &
      have_link("Visualizar", href: "/admin/punches/" + punch.id.to_s)
  end
end
