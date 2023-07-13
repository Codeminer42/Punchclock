# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewAdmin::EvaluationsController do
  render_views

  describe 'GET #index' do
    context 'when the user is signed in' do
      before do
        sign_in(user)
      end

      context 'when the user is an admin' do
        let(:user)         { create(:user, :admin) }
        let!(:english)     { create(:evaluation, :english, evaluation_date: 5.days.from_now, created_at: 1.month.ago) }
        let!(:performance) { create(:evaluation, evaluation_date: 5.months.ago, created_at: 8.months.ago) }
        let!(:expired)     { create(:evaluation, evaluation_date: 3.days.ago, created_at: 6.months.ago) }
        let!(:recent)      { create(:evaluation, evaluation_date: 1.day.ago, created_at: Date.today) }

        it 'renders the index template' do
          get :index

          expect(response).to render_template(:index)
        end

        it 'assigns all evaluations' do
          get :index

          expect(assigns(:evaluations)).to contain_exactly(english, performance, expired, recent)
        end

        context 'when filtering by evaluator_id' do
          let(:evaluator) { english.evaluator }

          it 'assigns evaluations correctly' do
            get :index, params: { evaluator_id: evaluator.id }

            expect(assigns(:evaluations)).to contain_exactly(english)
          end
        end

        context 'when filtering by evaluated_id' do
          let(:evaluated) { recent.evaluated }

          it 'assigns evaluations correctly' do
            get :index, params: { evaluated_id: evaluated.id }

            expect(assigns(:evaluations)).to contain_exactly(recent)
          end
        end

        context 'when filtering by questionnaire_type' do
          it 'assigns evaluations correctly' do
            get :index, params: { questionnaire_type: 1 }

            expect(assigns(:evaluations)).to contain_exactly(performance, expired, recent)
          end
        end

        context 'when filtering by created_at_start and created_at_end' do
          it 'assigns evaluations correctly' do
            get :index, params: { created_at_start: 1.year.ago, created_at_end: 3.months.ago }

            expect(assigns(:evaluations)).to contain_exactly(performance, expired)
          end
        end

        context 'when filtering by evaluation_date_start and evaluation_date_end' do
          it 'assigns evaluations correctly' do
            get :index, params: { evaluation_date_start: Date.today, evaluation_date_end: 10.days.from_now }

            expect(assigns(:evaluations)).to contain_exactly(english)
          end
        end

        context 'when a filtering param is invalid' do
          it 'returns http ok' do
            get :index, params: { evaluator_id: 'invalid' }

            expect(response).to have_http_status(:ok)
          end
        end
      end

      context 'when the user is not an admin' do
        let(:user) { create(:user) }

        it 'redirects to the root path' do
          get :index

          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'when the user is not signed in' do
      it 'redirects to the root path' do
        get :index

        expect(response).to redirect_to(root_path)
      end
    end
  end
end
