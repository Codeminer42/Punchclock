require 'rails_helper'

RSpec.describe Talk, type: :request do
  describe 'GET #index' do
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

  describe 'GET #edit' do
    let(:user) { create(:user) }
    let(:talk) { create(:talk, user_id: user.id) }
    let(:talk_not_from_user) { create(:talk) }

    context 'when the user is logged in' do
      before do
        sign_in user
      end

      context 'when talk belongs to user' do
        it 'has http status 200' do
          get edit_talk_path(talk.id)

          expect(response).to have_http_status(:ok)
        end

        it 'renders the edit template' do
          get edit_talk_path(talk.id)

          expect(response).to render_template(:edit)
        end
      end

      context 'when talk does not belong to user' do
        it 'redirects to /404' do
          get edit_talk_path(talk_not_from_user.id)

          expect(response).to redirect_to('/404')
        end
      end
    end

    context 'when the user is not logged in' do
      it 'redirects the user to the sign in page' do
        get edit_talk_path(talk.id)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PUT/PATCH #update' do
    let(:user) { create(:user) }
    let(:talk) { create(:talk, user_id: user.id) }
    let(:talk_not_from_user) { create(:talk) }

    context 'when the user is logged in' do
      before do
        sign_in user
      end

      context 'when params are valid' do
        let(:talk_valid_params) do
          {
            talk: {
              event_name: 'RailsConf'
            }
          }
        end

        context 'when talk belongs to signed in user' do
          it 'has http status 302' do
            put talk_path(talk.id), params: talk_valid_params

            expect(response).to have_http_status(:found)
          end

          it 'updates the talk' do
            expect do
              put talk_path(talk.id), params: talk_valid_params
            end.to change { talk.reload.event_name }.to('RailsConf')
          end
        end

        context 'when talk does not belong to signed in user' do
          it 'does not update' do
            expect { put talk_path(talk.id), params: talk_valid_params }
              .not_to change(Talk.find(talk_not_from_user.id), :event_name)
          end
        end
      end

      context 'when params are invalid' do
        let(:talk_invalid_params) do
          {
            talk: {
              event_name: nil
            }
          }
        end

        it 'has http status 200' do
          put talk_path(talk.id), params: talk_invalid_params

          expect(response).to have_http_status(:ok)
        end

        it 'does not update the talk' do
          expect { put talk_path(talk.id), params: talk_invalid_params }
            .not_to change { talk.reload.event_name }
        end
      end
    end
  end
end
