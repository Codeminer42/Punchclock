# frozen_string_literal: true

require 'rails_helper'

describe 'Repository', type: :feature do
  let(:admin_user) { create(:user, :super_admin, occupation: :administrative) }
  let!(:repository) { create(:repository) }

  before do
    sign_in(admin_user)
    visit '/admin/repositories'
  end

  describe 'Index' do
    it 'must find fields "Link" and "Company" on table' do
      within 'table' do
          expect(page).to have_text('Link') &
                        have_text('Linguagem') &
                        have_text('Empresa')
      end
    end
  end

  describe 'Filters' do
    it 'by link' do
      within '#filters_sidebar_section' do
        expect(page).to have_text('Link') & have_text('Linguagem')
      end
    end

    it 'by company' do
      within '#filters_sidebar_section' do
        expect(page).to have_select('Empresa')
      end
    end
  end

  describe 'Actions' do
    describe 'Show' do
      before do
        within 'table' do
          find_link('Visualizar', href: "/admin/repositories/#{repository.id}").click
        end
      end

      it 'must have labels' do
        expect(page).to have_text('Empresa') &
                        have_text('Link') &
                        have_text('Linguagem') &
                        have_text('Criado em') &
                        have_text('Atualizado em')
      end

      it 'have repository table with correct information' do
        expect(page).to have_text(repository.company) &
                        have_text(repository.link) &
                        have_text(repository.language) &
                        have_text(I18n.l(repository.created_at, format: :long)) &
                        have_text(I18n.l(repository.updated_at, format: :long))
      end
    end

    describe 'New' do
      before do
        within '.action_items' do
          click_link 'Novo(a) Repositório'
        end
      end

      it 'must have the form working' do
        find('#repository_company_id').find(:option, repository.company.name).select_option
        fill_in 'Link', with: 'https://github.com/example'
        fill_in 'Linguagem', with: 'Ruby on Rails'

        click_button 'Criar Repositório'
        expect(page).to have_css('.flash_notice', text: 'Repositório foi criado com sucesso.') &
                        have_text(repository.company) &
                        have_text('Ruby on Rails') &
                        have_text('https://github.com/example')
      end
    end

    describe 'Edit' do
      before do
        visit "/admin/repositories/#{repository.id}"
        find_link('Editar Repositório', href: "/admin/repositories/#{repository.id}/edit").click
      end

      it 'must have labels' do
        within 'form' do
          expect(page).to have_text('Link') &
                          have_text('Linguagem') &
                          have_text('Empresa')
        end
      end

      it 'updates repository information' do
        find('#repository_link').fill_in with: 'https://github.com/new_link'
        find('#repository_language').fill_in with: 'Javascript'

        click_button 'Atualizar Repositório'

        expect(page).to have_css('.flash_notice', text: 'Repositório foi atualizado com sucesso.') &
                        have_text('https://github.com/new_link') &
                        have_text('Javascript') 
      end
    end
  end
end
