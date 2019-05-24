# frozen_string_literal: true

require 'rails_helper'

feature "Company", type: :feature do
  let(:admin_user) { create(:super) }
  let!(:company) { create(:company) }

  before do
    admin_sign_in(admin_user)
  end

  scenario 'index' do
    click_link 'Empresas'

    expect(page).to have_content('Empresas')
  end

  describe 'filter' do
    before do
      visit '/admin/companies'
    end

    it 'by company name' do
      within '#filters_sidebar_section' do
        expect(page).to have_select('Nome', options: Company.pluck(:name) << 'Qualquer')
      end
    end
  end

  scenario 'view' do
    click_link 'Empresas'
    first('.odd').click_link('Visualizar')

    expect(page).to have_content('Detalhes do(a) Empresa')
  end

  scenario 'edit' do
    click_link 'Empresas'
    first('.odd').click_link('Editar')

    expect(page).to have_content('Editar Empresa')
  end

  scenario 'new company' do
    click_link 'Empresas'
    click_link 'Novo(a) Empresa'

    expect(page).to have_content('Novo(a) Empresa')

    click_button 'Criar Empresa'

    expect(page).to have_content('não pode ficar em branco')

    fill_in 'company_name', with: 'Empresa'
    click_button 'Criar Empresa'

    expect(page).to have_content('Empresa foi criado com sucesso.')
  end
end
