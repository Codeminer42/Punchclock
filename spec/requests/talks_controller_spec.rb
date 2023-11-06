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

  describe 'GET new' do
    let(:user) { create(:user) }

    context 'when the user is logged in' do
      before do
        sign_in user
      end

      it 'has status 200' do
        get new_talk_path

        expect(response).to have_http_status(:ok)
      end

      it 'renders the new template' do
        get new_talk_path

        expect(response).to render_template(:new)
      end
    end

    context 'when the user is not logged in' do
      it 'redirects the user to the sign in page' do
        get new_talk_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST create' do
    let(:user) { create(:user) }

    context 'when the user is logged in' do
      before do
        sign_in user
      end

      context 'when params are valid' do
        let(:talk_valid_params) do
          attributes_for(:talk)
        end

        it 'has 302 status' do
          post talks_path, params: { talk: talk_valid_params }

          expect(response).to have_http_status(:found)
        end

        it 'creates a new talk' do
          expect do
            post talks_path, params: { talk: talk_valid_params }
          end.to change { Talk.where(user_id: user.id).count }.by(1)
        end
      end

      context 'when params are invalid' do
        let(:talk_invalid_params) do
          {
            event_name: '',
            talk_title: 'some title',
            date: '10/10/2000'
          }
        end

        it 'has 200 status' do
          post talks_path, params: { talk: talk_invalid_params }

          expect(response).to have_http_status(:ok)
        end

        it 'does not create a new talk' do
          expect do
            post talks_path, params: { talk: talk_invalid_params }
          end.not_to(change { Talk.count })
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is signed in' do
      let!(:user) { create(:user) }
      let!(:talk) { create(:talk, user:) }
      let!(:other_talk) { create(:talk) }

      before { sign_in user }

      context 'when talk belongs to signed in user' do
        it 'deletes the talk' do
          expect { delete talk_path(talk.id) }.to change(Talk, :count).by(-1)
        end

        it 'redirects to talks index' do
          delete talk_path(talk.id)

          expect(response).to redirect_to(talks_path)
        end
      end

      context 'when education experience does not belong to signed in user' do
        it 'redirects to /404' do
          delete education_experience_path(other_talk.id)

          expect(response).to redirect_to('/404')
        end

        it 'does not delete the talk' do
          expect { delete talk_path(other_talk.id) }.not_to change(Talk, :count)
        end
      end
    end

    context 'when user is not signed in' do
      let(:talk) { create(:talk) }

      it 'redirects to sign in page' do
        delete talk_path(talk.id)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
