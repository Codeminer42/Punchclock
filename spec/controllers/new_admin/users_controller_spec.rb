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

  describe 'GET #edit' do
    let(:user) { create(:user, name: 'Jorge').decorate }
    let(:bob)  { create(:user, name: 'Bob') }

    context 'when the user is signed in' do
      before do
        sign_in(user)
      end

      context 'when the user is an admin' do
        let(:user) { create(:user, :admin, name: 'Jorge').decorate }

        it 'returns successful status' do
          get :edit, params: { id: bob.id }

          expect(response).to have_http_status(:ok)
        end

        it 'assigns the correct user to @user' do
          get :edit, params: { id: bob.id }

          expect(assigns(:user)).to eq(bob)
        end
      end

      context 'when the user is not an admin' do
        it 'redirects to the root path' do
          get :edit, params: { id: bob.id }

          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'when the user is not signed in' do
      it 'redirects to the sign in path' do
        get :edit, params: { id: bob.id }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH #update' do
    let(:bob)                { create(:user, name: 'bob', email: 'bob@example.com') }
    let(:user)               { create(:user) }
    let(:updated_attributes) { { name: "Updated User", email: "updated.user@codeminer42.com" } }

    context 'when the user is signed in' do
      before do
        sign_in(user)
      end

      context 'when the user is an admin' do
        let(:user) { create(:user, :admin) }

        context 'with valid attributes' do
          it 'updates the user' do
            patch :update, params: { id: bob.id, user: updated_attributes }

            bob.reload

            aggregate_failures do
              expect(bob.name).to eq("Updated User")
              expect(bob.email).to eq("updated.user@codeminer42.com")
            end
          end

          it 'redirects to user show page' do
            patch :update, params: { id: bob.id, user: updated_attributes }

            expect(response).to redirect_to(new_admin_admin_user_path(bob))
          end
        end

        context 'with invalid attributes' do
          it 'does not update the user' do
            invalid_attributes = { name: "", email: "invalid_email" }

            patch :update, params: { id: bob.id, user: invalid_attributes }

            bob.reload

            aggregate_failures do
              expect(bob.name).not_to eq("")
              expect(bob.email).not_to eq("invalid_email")
            end
          end

          it 'flashes error and redirects to edit user page' do
            invalid_attributes = { name: "", email: "invalid_email" }

            patch :update, params: { id: bob.id, user: invalid_attributes }

            aggregate_failures do
              expect(flash[:alert]).to be_present
              expect(response).to redirect_to(edit_new_admin_admin_user_path(bob)) 
            end
          end
        end
      end

      context 'when the user is not an admin' do
        it 'redirects to the root path' do
          patch :update, params: { id: bob.id, user: updated_attributes }

          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'when the user is not signed in' do
      it 'redirects to the sign in path' do
        patch :update, params: { id: bob.id, user: updated_attributes }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
