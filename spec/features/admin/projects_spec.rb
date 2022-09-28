# frozen_string_literal: true

require 'rails_helper'

describe 'Projects', type: :feature do
  let(:admin_user) { create(:user, :admin, occupation: :administrative) }
  let!(:project)   { create(:project) }

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
      before do
        within '.action_items' do
          click_link 'Novo(a) Projeto'
        end
      end

      it 'must have the form working' do
        find('#project_name').fill_in with: 'MinerCamp'
        find('#project_market').find(:option, 'Interno').select_option

        click_button 'Criar Projeto'

        expect(page).to have_text('Projeto foi criado com sucesso.') &
                        have_text('MinerCamp')
      end

      it 'must not work with a project with the same name' do
        find('#project_name').fill_in with: project.name
        find('#project_market').find(:option, 'Interno').select_option

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
                            have_text("Alocações") &
                            have_css('.row-name', text: project.name) &
                            have_css('.row-active', text: 'Sim')
          end
        end

        context 'contact information panel' do
          let!(:project_contact_information) { create(:project_contact_information, project: project) }
          before { refresh }

          it 'delete a contact information' do
            within '#principal' do
              find_link('Remover', href: "/admin/projects/#{project_contact_information.project_id}/project_contact_information?project_contact_information_id=#{project_contact_information.id}").click
            end

            expect(page).to have_current_path(admin_project_path(project.id)) &
              have_css('.flash_notice', text: 'As Informações de Contato foram removidas com sucesso!')
          end
        end
      end

      context 'on allocate users tab' do
        let!(:users){ create_list(:user, 2) }
        before { refresh }
        
        it 'fills the form correctly' do
          within '#alocar-usuarios' do
            select users.first.name, from: 'Usuários não alocados*'
            find('#allocate_users_form_start_at').fill_in with: '2019-06-25'
            find('#allocate_users_form_end_at').fill_in with: '2019-06-30'
            click_button 'Criar Alocações'
          end

          expect(page).to have_current_path(admin_allocations_path) &
                          have_css('.flash_notice', text: 'Alocações salvas com sucesso.') &
                          have_text(users.first.name) &
                          have_text(project.name)
        end
      end

      context 'on contact information tab' do
        it 'fills the form correctly' do
          within '#adicionar-informacoes-de-contato' do
            find('#project_contact_information_name').fill_in with: 'Contact name'
            find('#project_contact_information_email').fill_in with: 'contact@email.com'
            click_button 'Salvar Informações de Contato'
          end

          expect(page).to have_current_path(admin_project_path(project.id)) &
                          have_css('.flash_notice', text: 'Informações de Contato foram salvas com sucesso!') &
                          have_text('Contact name') &
                          have_text('contact@email.com')
        end

        it 'let the fields of the form blank' do
          within '#adicionar-informacoes-de-contato' do
            click_button 'Salvar Informações de Contato'
          end

          expect(page).to have_current_path(admin_project_path(project.id)) &
                          have_css('.flash_alert', text: 'Verifique as informações de contato e tente novamente. Detalhes: Nome não pode ficar em branco, E-Mail não pode ficar em branco')
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
                          have_text("Ativo")
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
