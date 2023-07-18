# frozen_string_literal: true

require 'rails_helper'

describe NewAdmin::UsersController do
  render_views

  let(:page) { Capybara::Node::Simple.new(response.body) }

  describe 'GET #show' do
    let(:user) { create(:user, name: 'Jorge').decorate }
    let!(:allocation) do
      create(:allocation,
             start_at: 2.months.after,
             end_at: 3.months.after,
             user: user,
             ongoing: true)
    end

    context 'when the user is signed in' do
      before do
        sign_in(user)
      end

      context 'when the user is an admin' do
        let(:user) { create(:user, :admin, name: 'Jorge').decorate }

        it 'returns a successful status' do
          get :show, params: { id: user.id }

          expect(response).to have_http_status(:ok)
        end

        it 'return the users information' do
          get :show, params: { id: user.id }

          expect(page).to have_content(user.name)
                      .and have_content(user.email)
                      .and have_content(I18n.t(user.otp_required_for_login?))
                      .and have_content(user.github)
                      .and have_content(user.office_city)
        end
      end

      context 'when the user is not an admin' do
        it 'redirects to the root path' do
          get :show, params: { id: user.id }

          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'when the user is not signed in' do
      it 'redirects to the sign in path' do
        get :show, params: { id: user.id }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
