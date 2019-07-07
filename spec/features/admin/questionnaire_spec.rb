# frozen_string_literal: true

require 'rails_helper'

describe 'Admin Questionaire', type: :feature do
  let(:admin_user)     { create(:user, :admin, occupation: :administrative) }
  let!(:questionnaire) { create(:questionnaire, active: true, company: admin_user.company) }

  before do
    sign_in(admin_user)
    visit '/admin/questionnaires'
  end

  describe 'Filters' do
    it 'by title' do
      within '#filters_sidebar_section' do
        expect(page).to have_css('label', text: 'Título')
      end
    end

    it 'by questionnaire kind' do
      create(:questionnaire)
      create(:questionnaire, :kind_english)
      visit '/admin/questionnaires'

      within '#filters_sidebar_section' do
        expect(page).to have_select('Tipo', options: Questionnaire.kinds.keys << 'Qualquer')
      end
    end

    it 'by active' do
      visit '/admin/questionnaires'

      within '#filters_sidebar_section' do
        expect(page).to have_select('Ativo', options: ['Sim', 'Não', 'Qualquer'])
      end
    end

    it 'by created at' do
      within '#filters_sidebar_section' do
        expect(page).to have_css('label', text: 'Criado em')
      end
    end
  end

  describe 'Actions' do
    describe 'New' do
      before do
        within '.action_items' do
          click_link 'Novo(a) Questionário'
        end
      end

      it 'must have the form working' do
        find('#questionnaire_title').fill_in with: 'Performance v2.5'
        find('#questionnaire_kind').find(:option, 'Performance').select_option
        fill_in 'Descrição', with: 'Simple Description'

        click_button 'Criar Questionário'

        expect(page).to have_text('Questionário foi criado com sucesso.') &
                        have_text('Performance v2.5') &
                        have_text('performance') &
                        have_css('.row-active', text: 'Não') &
                        have_css('.row-description', text: 'Simple Description')
      end
    end

    describe 'Show' do
      it 'must have labels' do
        visit "/admin/questionnaires/#{questionnaire.id}"

        within '.attributes_table.questionnaire' do
          expect(page).to have_text('Título')  &
                          have_text('Tipo') &
                          have_text('Ativo') &
                          have_text('Descrição') &
                          have_text('Criado em') &
                          have_text('Atualizado em') &
                          have_text('Perguntas')
        end
      end

      context 'when questionnaire is not being used' do
        before do
          visit "/admin/questionnaires/#{questionnaire.id}"
        end

        it 'have edit action' do
          expect(page).to have_link('Editar Questionário', href: "/admin/questionnaires/#{questionnaire.id}/edit")
        end

        it 'have delete action' do
          expect(page).to have_link('Remover Questionário', href: "/admin/questionnaires/#{questionnaire.id}")
        end
      end

      context 'when questionnaire is being used' do
        let!(:evaluation) { create(:evaluation, questionnaire: questionnaire) }

        before do
          visit "/admin/questionnaires/#{evaluation.questionnaire.id}"
        end

        it 'have no edit action' do
          expect(page).not_to have_link('Editar Questionário', href: "/admin/questionnaires/#{evaluation.questionnaire.id}/edit")
        end

        it 'have no delete action' do
          expect(page).not_to have_link('Remover Questionário', href: "/admin/questionnaires/#{evaluation.questionnaire.id}")
        end
      end
    end

    describe 'Edit' do
      before do
        visit "/admin/questionnaires/#{questionnaire.id}"
        click_link('Editar Questionário')
      end

      it 'must have labels' do
        within 'form' do
          expect(page).to have_text('Título')  &
                          have_text('Tipo') &
                          have_text('Ativo') &
                          have_text('Descrição') &
                          have_text('Adicionar Novo(a) Pergunta')
        end
      end

      it 'updates questionnaire information' do
        find('#questionnaire_title').fill_in with: 'Performance v3'

        click_button 'Atualizar Questionário'

        expect(page).to have_text('Questionário foi atualizado com sucesso.') &
                        have_text('Performance v3')
      end
    end

    describe 'Delete' do
      before do
        visit "/admin/questionnaires/#{questionnaire.id}"
      end

      it 'cancel delete questionnaire', js: true do
        page.dismiss_confirm do
          find_link('Remover Questionário', href: "/admin/questionnaires/#{questionnaire.id}").click
        end

        expect(page).to have_link('Remover Questionário', href: "/admin/questionnaires/#{questionnaire.id}")
      end

      it 'confirm delete questionnaire', js: true do
        page.accept_confirm do
          find_link('Remover Questionário', href: "/admin/questionnaires/#{questionnaire.id}").click
        end

        expect(page).to have_text('Questionário foi deletado com sucesso.') &
                        have_no_link(questionnaire.title, href: "/admin/questionnaires/#{questionnaire.id}")
      end
    end

    describe 'Toggle active' do
      before do
        visit "/admin/questionnaires/#{questionnaire.id}"
      end

      context 'when questionnaire is active' do
        it 'show deactive button' do
          expect(page).to have_link('Desativar Questionário')
        end

        it 'toggle to disable' do
          click_link 'Desativar Questionário'

          expect(page).to have_text('Questionário foi atualizado com sucesso.') &
                          have_css('.status_tag', text: 'Não' )
        end
      end

      context 'when questionnaire is not active' do
        let!(:questionnaire) { create(:questionnaire, active: false, company: admin_user.company) }

        it 'show deactive button' do
          expect(page).to have_link('Ativar Questionário')
        end

        it 'toggle to active' do
          click_link 'Ativar Questionário'

          expect(page).to have_text('Questionário foi atualizado com sucesso.') &
                          have_css('.status_tag', text: 'Sim' )
        end
      end
    end
  end
end
