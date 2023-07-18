# frozen_string_literal: true

require 'rails_helper'

describe NewAdmin::PunchesController do
  render_views

  let(:page) { Capybara::Node::Simple.new(response.body) }

  describe 'GET #show' do
    let(:punch) { FactoryBot.create(:punch).decorate }

    context 'when the user is signed in' do
      before do
        sign_in(user)
      end

      context 'when the user is an admin' do
        let(:user) { create(:user, :admin) }

        it 'returns a successful status' do
          get :show, params: { id: punch.id }

          expect(response).to have_http_status(:ok)
        end

        it 'returns the punch' do
          get :show, params: { id: punch.id }

          expect(page).to have_content(punch.user_name)
                      .and have_content(punch.project_name)
                      .and have_content(punch.date)
                      .and have_content(punch.from)
                      .and have_content(punch.to)
                      .and have_content(punch.delta)
        end
      end

      context 'when the user is not an admin' do
        let(:user) { create(:user) }

        it 'redirects to the root path' do
          get :show, params: { id: punch.id }

          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'when the user is not signed in' do
      it 'redirects to the sign in path' do
        get :show, params: { id: punch.id }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
