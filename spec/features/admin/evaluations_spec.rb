# frozen_string_literal: true

require 'rails_helper'

describe 'Admin Evaluation', type: :feature do
  let(:admin_user) { create(:user, :admin, occupation: :administrative) }

  before do
    sign_in(admin_user)
  end

  describe 'Filters' do
    let(:evaluator_user) { create(:user, :active_user, company: admin_user.company) }
    let(:evaluated_user) { create(:user, :active_user, company: admin_user.company) }

    let!(:evaluation1) do
      create(:evaluation,
             :english,
             evaluator: evaluator_user,
             evaluation_date: 3.weeks.ago,
             created_at: 5.months.ago,
             company: admin_user.company)
    end

    let!(:evaluation2) do
      create(:evaluation,
             :performance,
             evaluated: evaluated_user,
             evaluation_date: 5.weeks.ago,
             created_at: 8.months.ago,
             company: admin_user.company)
    end

    before do
      visit '/admin/evaluations'
    end

    it 'by evaluator' do
      within '#filters_sidebar_section' do
        expect(page).to have_select('Avaliador', options: admin_user.company.users.pluck(:name) << 'Qualquer')

        select evaluator_user.name, from: 'q_evaluator_id'
        click_button 'Filtrar'
      end

      within_table 'index_table_evaluations' do
        expect(page).to have_css('tbody tr', count: 1)
        expect(page).to have_selector("#evaluation_#{evaluation1.id}", count: 1)
        expect(page).not_to have_selector("#evaluation_#{evaluation2.id}")
      end
    end

    it 'by evaluated' do
      within '#filters_sidebar_section' do
        expect(page).to have_select('Avaliado', options: admin_user.company.users.pluck(:name) << 'Qualquer')

        select evaluated_user.name, from: 'q_evaluated_id'
        click_button 'Filtrar'
      end

      within_table 'index_table_evaluations' do
        expect(page).to have_css('tbody tr', count: 1)
        expect(page).not_to have_selector("#evaluation_#{evaluation1.id}")
        expect(page).to have_selector("#evaluation_#{evaluation2.id}", count: 1)
      end
    end

    it 'by questionnaire kind' do
      within '#filters_sidebar_section' do
        expect(page).to have_select('Tipo do Questionário', options: Questionnaire.kind.values.map { |kind| kind.text.titleize } << 'Qualquer')

        select Questionnaire.kind.performance.text.titleize, from: 'q_questionnaire_kind'
        click_button 'Filtrar'
      end

      within_table 'index_table_evaluations' do
        expect(page).to have_css('tbody tr', count: 1)
        expect(page).not_to have_selector("#evaluation_#{evaluation1.id}")
        expect(page).to have_selector("#evaluation_#{evaluation2.id}", count: 1)
      end
    end

    it 'by created at' do
      within '#filters_sidebar_section' do
        expect(page).to have_css('label', text: 'Criado em')

        fill_in 'q_created_at_gteq_datetime', with: 9.months.ago
        fill_in 'q_created_at_lteq_datetime', with: 7.months.ago

        click_button 'Filtrar'
      end

      within_table 'index_table_evaluations' do
        expect(page).to have_css('tbody tr', count: 1)
        expect(page).not_to have_selector("#evaluation_#{evaluation1.id}")
        expect(page).to have_selector("#evaluation_#{evaluation2.id}", count: 1)
      end
    end

    it 'by evaluation date' do
      within '#filters_sidebar_section' do
        expect(page).to have_css('label', text: 'Data da avaliação')

        fill_in 'q_evaluation_date_gteq', with: 4.weeks.ago
        fill_in 'q_evaluation_date_lteq', with: 2.weeks.ago

        click_button 'Filtrar'
      end

      within_table 'index_table_evaluations' do
        expect(page).to have_css('tbody tr', count: 1)
        expect(page).to have_selector("#evaluation_#{evaluation1.id}", count: 1)
        expect(page).not_to have_selector("#evaluation_#{evaluation2.id}")
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
                        have_css('td', text: evaluation.english_level.text.titleize) &
                        have_css('a',  text: evaluation.evaluator.name) &
                        have_css('a',  text: evaluation.evaluated.name) &
                        have_css('td', text: I18n.l(evaluation.evaluator.created_at, format: :long)) &
                        have_css('td', text: evaluation.questionnaire.title) &
                        have_css('td', text: evaluation.observation) &
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
