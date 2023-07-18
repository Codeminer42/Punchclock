# frozen_string_literal: true

require 'rails_helper'

describe 'Evaluations', type: :feature do
  let(:evaluator_user) { create(:user, :active_user) }
  let(:evaluated_user) { create(:user, :active_user) }
  let(:admin_user)     { create(:user, :admin, occupation: :administrative) }

  before do
    sign_in(admin_user)
  end

  describe 'Filters' do
    let!(:english_evaluation) do
      create(:evaluation, :english, evaluator: evaluator_user, evaluation_date: 3.weeks.ago, created_at: 5.months.ago)
    end
    let!(:performance_evaluation) do
      create(:evaluation, :performance, evaluated: evaluated_user, evaluation_date: 5.weeks.ago, created_at: 8.months.ago)
    end

    before do
      visit '/new_admin/evaluations'
    end

    context 'by evaluator' do
      it 'shows filtered evaluations' do
        within '#filters_sidebar_section' do
          expect(page).to have_select('Avaliador', options: User.active.pluck(:name) << 'Qualquer')

          select evaluator_user.name, from: 'Avaliador'
          click_button 'Filtrar'
        end

        within_table 'index_table_evaluations' do
          expect(page).to have_css('tbody tr', count: 1) and
            have_selector("#evaluation_#{english_evaluation.id}", count: 1) and
            have_no_selector("#evaluation_#{performance_evaluation.id}")
        end
      end
    end

    context 'by evaluated' do
      it 'shows filtered evaluations' do
        within '#filters_sidebar_section' do
          expect(page).to have_select('Avaliado', options: User.active.pluck(:name) << 'Qualquer')

          select evaluated_user.name, from: 'Avaliado'
          click_button 'Filtrar'
        end

        within_table 'index_table_evaluations' do
          expect(page).to have_css('tbody tr', count: 1) and
            have_no_selector("#evaluation_#{english_evaluation.id}") and
            have_selector("#evaluation_#{performance_evaluation.id}", count: 1)
        end
      end
    end

    context 'by questionnaire kind' do
      it 'shows filtered evaluations' do
        within '#filters_sidebar_section' do
          expect(page).to have_select('Tipo de questionário', options: Questionnaire.kind.values.map { |kind| kind.text.titleize } << 'Qualquer')

          select Questionnaire.kind.performance.text.titleize, from: 'Tipo de questionário'
          click_button 'Filtrar'
        end

        within_table 'index_table_evaluations' do
          expect(page).to have_css('tbody tr', count: 1) and
            have_no_selector("#evaluation_#{english_evaluation.id}") and
            have_selector("#evaluation_#{performance_evaluation.id}", count: 1)
        end
      end
    end

    context 'by created at' do
      it 'shows filtered evaluations' do
        within '#filters_sidebar_section' do
          expect(page).to have_css('label', text: 'Criado em')

          fill_in 'created_at_start', with: 9.months.ago
          fill_in 'created_at_end', with: 7.months.ago

          click_button 'Filtrar'
        end

        within_table 'index_table_evaluations' do
          expect(page).to have_css('tbody tr', count: 1) and
            have_no_selector("#evaluation_#{english_evaluation.id}") and
            have_selector("#evaluation_#{performance_evaluation.id}", count: 1)
        end
      end
    end

    context 'by evaluation date' do
      it 'shows filtered evaluations' do
        within '#filters_sidebar_section' do
          expect(page).to have_css('label', text: 'Data da avaliação')

          fill_in 'evaluation_date_start', with: 4.weeks.ago
          fill_in 'evaluation_date_end', with: 2.weeks.ago

          click_button 'Filtrar'
        end

        within_table 'index_table_evaluations' do
          expect(page).to have_css('tbody tr', count: 1) and
            have_selector("#evaluation_#{english_evaluation.id}", count: 1) and
            have_no_selector("#evaluation_#{performance_evaluation.id}")
        end
      end
    end

    context 'with no filter selected' do
      it 'shows all evaluations' do
        within_table 'index_table_evaluations' do
          expect(page).to have_css('tbody tr', count: 2) and
            have_selector("#evaluation_#{english_evaluation.id}", count: 1) and
            have_selector("#evaluation_#{performance_evaluation.id}", count: 1)
        end
      end
    end

    context 'when no evaluation is found' do
      it 'shows "No evaluation found" message' do
        within '#filters_sidebar_section' do
          expect(page).to have_css('label', text: 'Criado em')

          fill_in 'created_at_start', with: 1.year.from_now

          click_button 'Filtrar'
        end

        expect(page).to have_content('Nenhuma avaliação encontrada')
      end
    end
  end

  describe 'Actions' do
    let!(:evaluation) { create(:evaluation, :with_answers, answer_count: 2, english_level: 'beginner') }

    before do
      visit '/new_admin/evaluations'
    end

    context 'when on show' do
      before do
        find_link('Visualizar', href: "/new_admin/evaluations/#{evaluation.id}").click
      end

      it 'have the evaluation answers on show' do
        within '#answers-table' do
          expect(page).to have_css('tbody tr', count: 2)
        end
      end

      it 'have all evaluation attributes except updated at' do
        expect(page).to have_css('td', text: evaluation.score) and
          have_css('td', text: evaluation.english_level.text.titleize) and
          have_css('a',  text: evaluation.evaluator.name) and
          have_css('a',  text: evaluation.evaluated.name) and
          have_css('td', text: I18n.l(evaluation.evaluator.created_at, format: :long)) and
          have_css('td', text: evaluation.questionnaire.title) and
          have_css('td', text: evaluation.observation) and
          have_css('td', text: I18n.l(evaluation.evaluation_date, format: :long))
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
