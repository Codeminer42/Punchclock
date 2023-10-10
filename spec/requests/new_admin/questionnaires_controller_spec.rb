require 'rails_helper'

RSpec.describe NewAdmin::QuestionnairesController, type: :request do
  describe 'GET #index' do
    context 'when user is signed in' do
      context 'when user is admin' do
        let!(:questionnaires) { create_list(:questionnaire, 2) }
        let(:user) { create(:user, :admin) }
        before { sign_in user }

        it 'returns status code 200 ok' do
          get new_admin_questionnaires_path

          expect(response).to have_http_status(:ok)
        end

        it 'renders the index template' do
          get new_admin_questionnaires_path

          expect(response).to render_template(:index)
        end

        it 'shows the questionnaires' do
          get new_admin_questionnaires_path

          expect(response.body).to include(questionnaires[0].title)
          .and include(questionnaires[1].title)
        end
      end
    end
    context 'when user is not signed in' do
      it 'redirects to the sign in page' do
        get new_admin_questionnaires_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end