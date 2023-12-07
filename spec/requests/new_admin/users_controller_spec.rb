require 'rails_helper'

RSpec.describe NewAdmin::UsersController, type: :request do
  describe 'GET #index' do
    context 'when user is signed in' do
      context 'when user is admin' do
        let(:user) { create(:user, :admin) }
        before { sign_in user }

        context 'when no filters are applied' do
          let!(:users) { create_list(:user, 2) }

          it 'returns status code 200 ok' do
            get new_admin_admin_user_index_path

            expect(response).to have_http_status(:ok)
          end

          it 'renders the index template' do
            get new_admin_admin_user_index_path

            expect(response).to render_template(:index)
          end

          it 'shows the users' do
            get new_admin_admin_user_index_path

            expect(response.body).to include(users[0].name)
              .and include(users[1].name)
          end
        end

        context 'when name filter is applied' do
          let!(:user1) { create(:user, name: 'John Doe') }
          let!(:user2) { create(:user, name: 'Jane Doe') }

          it 'returns only the filtered users', :aggregate_failures do
            get new_admin_admin_user_index_path, params: { name: 'john' }

            expect(response.body).to include('John')
            expect(response.body).not_to include('Jane')
          end
        end

        context 'when pagination is applied' do
          let!(:users) { create_list(:user, 3) }

          it 'paginates the results', :aggregate_failures do
            get new_admin_admin_user_index_path, params: { per: 2 }

            expect(assigns(:users).count).to eq(2)
          end
        end
      end
    end

    context 'when user is not signed in' do
      it 'redirects to the sign in page' do
        get new_admin_admin_user_index_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is not admin' do
      let(:user) { create(:user) }

      before { sign_in user }

      it 'redirects to root page' do
        get new_admin_admin_user_index_path

        expect(response).to redirect_to(root_path)
      end
    end
  end
end
