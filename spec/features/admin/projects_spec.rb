# frozen_string_literal: true

require 'rails_helper'

describe 'Projects', type: :feature do
  let(:admin_user) { create(:user, :admin, occupation: :administrative) }
  let!(:project)   { create(:project, company: admin_user.company) }

  before do
    sign_in(admin_user)
    visit '/admin/projects'
  end

  describe 'Index' do
    it 'must find fields "Nome", "Ativo" and "Criado Em" on table' do
      within 'table' do
        expect(page).to have_text('Nome') &
                        have_text('Ativo') &
                        have_text('Criado em')
      end
    end
  end

  describe 'Filters' do
    it 'by name' do
      within '#filters_sidebar_section' do
        expect(page).to have_css('label', text: 'Nome')
      end
    end
  end

  describe 'Actions' do
    describe 'New' do
      let!(:client) { create(:client, company: admin_user.company) }
      let(:project) { create(:project, company: client.company, name: 'TRZ') }
      
      before do
        within '.action_items' do
          click_link 'Novo(a) Projeto'
        end
      end

      it 'must have the form working' do

        find('#project_name').fill_in with: 'MinerCamp'
        find('#project_client_id').find(:option, client.name).select_option

        click_button 'Criar Projeto'

        expect(page).to have_text('Projeto foi criado com sucesso.') &
                        have_text('MinerCamp') &
                        have_text(client.name)
      end

      it 'must not work with a project with the same name' do

        find('#project_name').fill_in with: 'TRZ'
        find('#project_client_id').find(:option, client.name).select_option

        click_button 'Criar Projeto'

        expect(page).to have_text('Projeto não pôde ser criado.')
      end
    end

    describe 'Show' do
      before do
        visit '/admin/projects'
        within 'table' do
          find_link(project.name, href: "/admin/projects/#{project.id}").click
        end
      end

      it 'have edit action' do
        expect(page).to have_link('Editar Projeto')
      end

      context 'on principal tab' do
        it 'finds labels and projects information' do
          within '#principal' do
            expect(page).to have_text("Nome")  &
                            have_text("Ativo") &
                            have_text("Cliente") &
                            have_text("Alocações") &
                            have_css('.row-name', text: project.name) &
                            have_css('.row-active', text: 'Sim') &
                            have_text(project.client || 'Vazio')
          end
        end
      end

      context 'on allocate users tab' do
        let!(:users){ create_list(:user, 2, company: admin_user.company) }
        before { refresh }
        
        it 'fills the form correctly' do
          within '#alocar-usuarios' do
            find("#allocate_users_form_not_allocated_users_#{users[0].id}").set(true)
            find("#allocate_users_form_not_allocated_users_#{users[1].id}").set(true)
            find('#allocate_users_form_start_at').fill_in with: '2019-06-25'
            find('#allocate_users_form_end_at').fill_in with: '2019-06-30'
            click_button 'Criar Alocações'
          end

          expect(page).to have_current_path(admin_allocations_path) &
                          have_css('.flash_notice', text: 'Alocações salvas com sucesso.') &
                          have_text(users[0].name) &
                          have_text(users[1].name) &
                          have_text(project.name)
        end
      end
    end

    describe 'Edit' do
      before do
        visit "/admin/projects/#{project.id}"
        click_link('Editar Projeto')
      end

      it 'have labels' do
        within 'form' do
          expect(page).to have_text("Nome")  &
                          have_text("Ativo") &
                          have_text("Cliente")
        end
      end

      it 'updates project information' do
        find('#project_name').fill_in with: "Punch/MinerCamp"

        click_button 'Atualizar Projeto'

        expect(page).to have_text('Projeto foi atualizado com sucesso.') &
                        have_css(".row-name td", text: 'Punch/MinerCamp')
      end
    end
  end
end
