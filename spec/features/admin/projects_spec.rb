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

      it 'must have labels' do
        within '#main_content' do
          expect(page).to have_text("Nome")  &
                          have_text("Ativo") &
                          have_text("Cliente") &
                          have_text("Alocações")
        end
      end

      it 'have project information' do
        expect(page).to have_css('.row-name', text: project.name) &
                        have_css('.row-active', text: 'Sim') &
                        have_text(project.client)
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
