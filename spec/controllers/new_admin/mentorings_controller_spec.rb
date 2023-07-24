# frozen_string_literal: true

RSpec.describe NewAdmin::MentoringsController do
  describe 'GET #index' do
    context 'when the user is signed in' do
      before do
        sign_in(user)
      end

      context 'when the user is an admin' do
        let(:user)    { create(:user, :admin) }
        let!(:mentor) { create(:user) }
        let!(:mentee) { create(:user, mentor: mentor) }

        it 'renders index template' do
          get :index

          expect(response).to render_template(:index)
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
      it 'redirects to the sign in path' do
        get :index

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
