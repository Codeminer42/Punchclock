require 'rails_helper'

RSpec.describe TalksController, type: :request do
  describe 'GET index' do
    context 'when user is authenticated' do
      let!(:user) { create(:user) }
      let!(:talk_list) { create_list(:talk, 2, user:) }

      before do
        sign_in user
      end

      it 'renders the index template' do
        get talks_path
        expect(response).to render_template(:index)
      end

      it 'has http status 200' do
        get talks_path
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is not authenticated' do
      before do
        get talks_path
      end

      it 'redirects to sign in page' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #show' do
    let(:user) { create(:user) }
    let(:user_talk) { create(:talk, user:) }
    let(:other_talk) { create(:talk) }

    context 'when user is logged in' do
      before { sign_in user }
      context 'when talk belongs to logged in user' do
        it 'renders the show template' do
          get talk_path(user_talk)

          expect(response).to render_template(:show)
        end
      end

      context 'when talk does not exist or does not belong to user' do
        it 'redirects to not found page' do
          get talk_path(other_talk)

          expect(response).to redirect_to('/404')
        end
      end
    end

    context 'when user is not logged in' do
      it 'redirects to sign in page' do
        get talk_path(other_talk)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
