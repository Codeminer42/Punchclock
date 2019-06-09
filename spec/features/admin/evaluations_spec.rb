# frozen_string_literal: true

require 'rails_helper'

describe 'Admin Evaluation', type: :feature do
  let(:admin_user) { create(:admin_user) }

  before do
    admin_sign_in(admin_user)
  end

  describe 'Filters' do
    before do
      create(:evaluation)
      visit '/admin/evaluations'
    end

    it 'by evaluator' do
      within '#filters_sidebar_section' do
        expect(page).to have_select('Avaliador', options: admin_user.company.users.pluck(:name) << 'Qualquer')
      end
    end

    it 'by evaluated' do
      within '#filters_sidebar_section' do
        expect(page).to have_select('Avaliado', options: admin_user.company.users.pluck(:name) << 'Qualquer')
      end
    end

    it 'by questionnaire kind' do
      within '#filters_sidebar_section' do
        expect(page).to have_select('Tipo do Questionário', options: Questionnaire.kinds.keys.map(&:titleize) << 'Qualquer')
      end
    end

    it 'by created at' do
      within '#filters_sidebar_section' do
        expect(page).to have_css('label', text: 'Criado em')
      end
    end
  end

  describe 'Actions' do
    let!(:evaluation) { create(:evaluation,
                               :with_answers,
                               answer_count: 2,
                               english_level: 'beginner',
                               company: admin_user.company )}

    before do
      visit '/admin/evaluations'
    end

    context 'when on show' do
      before do
        find_link('Visualizar', href: "/admin/evaluations/#{evaluation.id}").click
      end

      it 'have the evaluation answers on show' do
        within '.row-answers' do
          expect(page).to have_css('tbody tr', count: 2)
        end
      end

      it 'have all evaluation attributes except updated at' do
        expect(page).to have_css('td', text: evaluation.score) &
                        have_css('td', text: evaluation.english_level) &
                        have_css('a',  text: evaluation.evaluator.name) &
                        have_css('a',  text: evaluation.evaluated.name) &
                        have_css('td', text: I18n.l(evaluation.evaluator.created_at, format: :long)) &
                        have_css('td',  text: evaluation.questionnaire.title) &
                        have_css('td', text: evaluation.observation)
      end

      it 'have no edit action' do
        expect(page).to have_no_link('Editar Avaliação')
      end

      it 'have no delete action' do
        expect(page).to have_no_link('Remover Avaliação')
      end
    end
  end
end
