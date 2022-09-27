# frozen_string_literal: true

require 'rails_helper'

describe 'Admin Allocation', type: :feature do
  let(:admin_user)  { create(:user, :admin, occupation: :administrative) }
  let!(:user)       { create(:user) }
  let!(:project)    { create(:project) }
  let!(:allocation) do
    create(:allocation,
           start_at: Date.new(2019, 6, 17),
           user: user,
           project: project,
           ongoing: true
          )
  end

  before do
    sign_in(admin_user)
    visit '/admin/allocations'
  end

  describe 'Index' do
    it 'must find fields "Usuário", "Projeto", "Início", "Término", "Dias Restantes", and "Em progresso" on table' do
      within 'table' do
        expect(page).to have_text('Usuário') &
                        have_text('Projeto') &
                        have_text('Início') &
                        have_text('Término') &
                        have_text('Dias Restantes') &
                        have_text('Em progresso')
      end
    end
  end

  describe 'Filters' do
    before do
      create_list(:user, 2)
      create_list(:project, 1)
      visit '/admin/allocations'
    end

    it 'by user' do
      within '#filters_sidebar_section' do
        users_name = User.pluck(:name)
        expect(page).to have_select('Usuário', options: users_name << 'Qualquer')
      end
    end

    it 'by project' do
      within '#filters_sidebar_section' do
        expect(page).to have_select('Projeto', options: Project.all.pluck(:name) << 'Qualquer')
      end
    end
  end

  describe 'Actions' do
    describe 'New' do
      let!(:user_not_allocated) { create(:user) }
      let!(:project_not_active) { create(:project, :inactive) }

      before { click_link 'Novo(a) Alocação' }

      it 'renders the allocated users' do
        expect(page).to have_text(user.name)
      end

      it 'should not render project inactive' do
        expect(page).not_to have_text(project_not_active.name)
      end

      it 'should not render nil project' do
        expect(page).to have_select('allocation_project_id', options: ['', project.name])
      end

      it 'should render users not allocated' do
        expect(page).to have_text(user_not_allocated.name) &
                        have_text(project.name)
      end

      it 'must have the form working' do
        start_at = 1.week.after
        end_at = 50.weeks.after

        find('#allocation_user_id').find(:option, user_not_allocated.name).select_option
        find('#allocation_project_id').find(:option, project.name).select_option
        find('#allocation_start_at').fill_in with: start_at.strftime('%Y-%m-%d')
        find('#allocation_end_at').fill_in with: end_at.strftime('%Y-%m-%d')

        click_button 'Criar Alocação'

        expect(page).to have_text('Alocação foi criado com sucesso') &
                        have_css('.row-user', text: user_not_allocated.name) &
                        have_text(project.name) &
                        have_text(I18n.l(start_at, format: '%d de %B de %Y')) &
                        have_text(I18n.l(end_at, format: '%d de %B de %Y')) &
                        have_css('.row-days_left', text: 'Dias Restantes 350')
      end
    end

    describe 'Show' do
      let!(:punch) do
        create(:punch,
               user: user,
               project: project,
               from: DateTime.new(2019, 6, 17, 8, 0, 0, 0),
               to: DateTime.new(2019, 6, 17, 12, 0, 0, 0)).decorate
      end

      before do
        visit '/admin/allocations'
        within 'table' do
          find_link('Visualizar', href: "/admin/allocations/#{allocation.id}").click
        end
      end

      it 'have edit action' do
        expect(page).to have_link('Editar Alocação')
      end

      it 'have delete action' do
        expect(page).to have_link('Remover Alocação')
      end

      it 'must have labels' do
        within '.attributes_table.allocation' do
          expect(page).to have_text('Usuário')  &
                          have_text('Projeto') &
                          have_text('Início') &
                          have_text('Término') &
                          have_text('Em progresso')
        end
      end

      it 'have user information' do
        expect(page).to have_css('.row-user td', text: allocation.user.name) &
                        have_css('.row-project td', text: allocation.project.name) &
                        have_css('.row-start_at td', text: I18n.l(allocation.start_at, format: :long)) &
                        have_css('.row-end_at td', text: I18n.l(allocation.end_at, format: :long))
      end

      it 'have allocation punches information' do
        within "#punch_#{punch.id}" do
          expect(page).to have_text(punch.when) &
                          have_text(punch.from) &
                          have_text(punch.to) &
                          have_text(punch.delta) &
                          have_text('Não')
        end
      end

      it 'have button to download allocation punches' do
        expect(page).to have_link('Baixar CSV',
                                  href: admin_punches_path(q: { project_id_eq: allocation.project.id,
                                                                user_id_eq: allocation.user.id,
                                                                from_greater_than: Date.current - 60 }, format: :csv))
      end
    end

    describe 'Edit' do
      before do
        visit "/admin/allocations/#{allocation.id}"
        within '.action_items' do
          find_link('Editar Alocação', href: "/admin/allocations/#{allocation.id}/edit").click
        end
      end

      it 'must have labels' do
        within 'form' do
          expect(page).to have_text('Usuário') &
                          have_text('Projeto') &
                          have_text('Início') &
                          have_text('Término') &
                          have_text('Em progresso')
        end
      end

      it 'updates user information' do
        find('#allocation_end_at').fill_in with: Date.today.next_month

        click_button 'Atualizar Alocação'

        expect(page).to have_css('.flash_notice', text: 'Alocação foi atualizado com sucesso.') &
                        have_css('.row-user td', text: allocation.user.name) &
                        have_css('.row-project td', text: allocation.project.name) &
                        have_css('.row-start_at td', text: I18n.l(allocation.start_at, format: :long)) &
                        have_css('.row-end_at td', text: I18n.l(Date.today.next_month, format: :long))
      end

      it 'must show inactive project if user allocated' do
        project.disable!
        visit current_path
        expect(page).to have_select('allocation_project_id', options: ['', project.name])
      end
    end

    describe 'Destroy' do
      before do
        visit "/admin/allocations/#{allocation.id}"
      end

      it 'cancel delete allocation', js: true do
        page.dismiss_confirm do
          find_link('Remover Alocação', href: "/admin/allocations/#{allocation.id}").click
        end

        expect(page).to have_link('Remover Alocação', href: "/admin/allocations/#{allocation.id}")
      end

      it 'confirm delete allocation', js: true do
        page.accept_confirm do
          find_link('Remover Alocação', href: "/admin/allocations/#{allocation.id}").click
        end

        expect(page).to have_text('Alocação foi deletado com sucesso.') &
                        have_no_link('Remover Alocação', href: "/admin/allocations/#{allocation.id}")
      end
    end
  end
end
