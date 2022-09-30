# frozen_string_literal: true

require 'rails_helper'

describe "Punches with super admin_user", type: :feature do
  let(:admin_user) { create :user, :admin }
  let!(:punch) { create :punch }
  let!(:user) { create :user }
  let!(:project) { create :project }

  before do
    sign_in(admin_user)
  end

  it 'index' do
    click_link 'Punches'
    expect(page).to have_content('Punches') &
      have_link("Visualizar", href: "/admin/punches/" + punch.id.to_s) &
      have_link("Editar", href: "/admin/punches/" + punch.id.to_s + "/edit") &
      have_link("Remover", href: "/admin/punches/" + punch.id.to_s)
  end

  it 'filter' do
    click_link 'Punches'
    click_button 'Filtrar'

    expect(page).to have_content(punch.user.name)
  end
  
  context "on workday" do
    around do |example|
      travel_to(DateTime.new(2019, 06, 14, 18), &example)
    end

    it 'new punch' do
      click_link 'Punches'
      click_link 'Novo(a) Punch'

      expect(page).to have_content('Novo(a) Punch')

      click_button 'Criar Punch'
      expect(page).to have_content('não pode ficar em branco')

      select(user.name, from: 'punch_user_id').select_option
      select(project.name, from: 'punch_project_id').select_option
      fill_in 'punch_from', with: DateTime.new(2019, 06, 14, 9)
      fill_in 'punch_to', with: DateTime.new(2019, 06, 14, 12)
      click_button 'Criar Punch'

      expect(page).to have_content('Punch foi criado com sucesso.')
    end
  end
end

describe "Punches with normal admin_user", type: :feature do
  let(:admin_user) { create :user, :admin, occupation: :administrative }
  let!(:punch) { create :punch }

  before do
    sign_in(admin_user)

    visit '/admin/punches'
  end

  it 'index' do
    expect(page).to have_content('Punches') &
                    have_link("Visualizar", href: "/admin/punches/#{punch.id}")
  end

  describe 'Filters' do
    it 'by project' do
      within '#filters_sidebar_section' do
        expect(page).to have_select('Projeto', options: Project.all.pluck(:name) << 'Qualquer')
      end
    end

    it 'by user' do
      within '#filters_sidebar_section' do
        expect(page).to have_select('Usuário', options: User.all.pluck(:name) << 'Qualquer')
      end
    end
  end
end
