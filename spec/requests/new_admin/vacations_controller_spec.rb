# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewAdmin::VacationsController, type: :request do
  describe 'GET #index' do
    let(:vacations) { create_list(:vacation, 2) }

    context 'when user is signed in' do
      before { sign_in user }

      context 'when user is admin' do
        let(:user) { create(:user, :admin) }

        before { get new_admin_vacations_path }

        it 'renders index template' do
          expect(response).to render_template(:index)
        end

        context 'when pagination is applied' do
          let!(:vacations) { create_list(:vacation, 3) }

          it 'paginates results' do
            get new_admin_vacations_path, params: { per: 2 }
            expect(assigns(:vacations).count).to eq(2)
          end
        end
      end

      context 'when the user is not authorized' do
        let(:user) { create(:user) }

        it 'redirects to the root path' do
          get new_admin_vacations_path

          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'when the user is not signed in' do
      it 'redirects to sign in path' do
        get new_admin_vacations_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
