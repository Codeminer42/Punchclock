# frozen_string_literal: true

require 'rails_helper'

describe 'Admin Allocation', type: :feature do
  let(:admin_user)  { create(:admin_user) }
  let!(:user)       { create(:user, company: admin_user.company) }
  let!(:project)    { create(:project, company: admin_user.company) }
  let!(:allocation) { create(:allocation,
                              :with_end_at,
                              user: user,
                              project: project,
                              company: admin_user.company )}

  before do
    admin_sign_in(admin_user)
    visit '/admin/allocations'
  end

  describe 'Index' do
    it 'must find fields "Usuário", "Projeto", "Início", "Término" and "Dias Restantes" on table' do
      within 'table' do
        expect(page).to have_text('Usuário') &
                        have_text('Projeto') &
                        have_text('Início') &
                        have_text('Término') &
                        have_text('Dias Restantes')
      end
    end
  end

  describe 'Filters' do
    before do
      create_list(:user, 2, company: admin_user.company)
      create_list(:project, 1, company: admin_user.company)
      visit '/admin/allocations'
    end

    it 'by user' do
      within '#filters_sidebar_section' do
        expect(page).to have_select('Usuário', options: admin_user.company.users.pluck(:name) << 'Qualquer')
      end
    end

    it 'by project' do
      within '#filters_sidebar_section' do
        expect(page).to have_select('Projeto', options: admin_user.company.projects.pluck(:name) << 'Qualquer')
      end
    end
  end

  describe 'Actions' do
    describe 'New' do
      before { click_link 'Novo(a) Alocação' }

      it 'must have the form working' do

        find('#allocation_user_id').find(:option, user.name).select_option
        find('#allocation_project_id').find(:option, project.name).select_option
        find('#allocation_start_at').fill_in with: '2019-06-30'

        click_button 'Criar Alocação'

        expect(page).to have_text('Alocação foi criado com sucesso') &
                        have_css('.row-user', text: user.name) &
                        have_text(project.name) &
                        have_text('30 de Junho de 2019') &
                        have_css('.row-end_at', text: 'Vazio') &
                        have_css('.row-days_left', text: 'Vazio')
      end
    end

    describe 'Show' do
      before do
        visit '/admin/allocations'
        within 'table' do
          find_link("Visualizar", href: "/admin/allocations/#{allocation.id}").click
        end
      end

      it 'have edit action' do
        expect(page).to have_link('Editar Alocação')
      end

      it 'have delete action' do
        expect(page).to have_link('Remover Alocação')
      end

      it 'must have labels' do
        within 'table' do
          expect(page).to have_text("Usuário")  &
                          have_text("Projeto") &
                          have_text("Início") &
                          have_text("Término")
        end
      end

      it 'have user information' do
        expect(page).to have_css(".row-user td", text: allocation.user.name)  &
                        have_css(".row-project td", text: allocation.project.name) &
                        have_css(".row-start_at td", text: I18n.l(allocation.start_at, format: :long)) &
                        have_css(".row-end_at td", text: I18n.l(allocation.end_at, format: :long))
      end
    end

    describe 'Edit' do
      before do
        visit "/admin/allocations/#{allocation.id}"
        within '.action_items' do
          find_link("Editar Alocação", href: "/admin/allocations/#{allocation.id}/edit").click
        end
      end

      it 'must have labels' do
        within 'form' do
          expect(page).to have_text("Usuário")  &
                          have_text("Projeto") &
                          have_text("Início") &
                          have_text("Término")
        end
      end

      it 'updates user information' do
        find('#allocation_end_at').fill_in with: Date.today.next_month
        click_button 'Atualizar Alocação'

        expect(page).to have_css('.flash_notice', text: 'Alocação foi atualizado com sucesso.') &
                        have_css(".row-user td", text: allocation.user.name)  &
                        have_css(".row-project td", text: allocation.project.name) &
                        have_css(".row-start_at td", text: I18n.l(allocation.start_at, format: :long)) &
                        have_css(".row-end_at td", text: I18n.l(Date.today.next_month, format: :long))
      end
    end

    describe 'Destroy' do
      before do
        visit "/admin/allocations/#{allocation.id}"
      end

      it 'cancel delete allocation', js: true do
        page.dismiss_confirm do
          find_link("Remover Alocação", href: "/admin/allocations/#{allocation.id}").click
        end

        expect(page).to have_link('Remover Alocação', href: "/admin/allocations/#{allocation.id}")
      end

      it 'confirm delete allocation', js: true do
        page.accept_confirm do
          find_link("Remover Alocação", href: "/admin/allocations/#{allocation.id}").click
        end

        expect(page).to have_text('Alocação foi deletado com sucesso.') &
                        have_no_link('Remover Alocação', href: "/admin/allocations/#{allocation.id}")
      end
    end
  end
end
