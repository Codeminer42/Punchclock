# frozen_string_literal: true

require 'rails_helper'

describe NewAdmin::UsersController do
  render_views

  let(:user) { create(:user, name: "Jorge").decorate }
  let(:page) { Capybara::Node::Simple.new(response.body) }

  before do
    allow(controller).to receive(:authenticate_user!)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #show' do
    let!(:allocation) { create(:allocation,
                                start_at: 2.months.after,
                                end_at: 3.months.after,
                                user: user,
                                ongoing: true) }


    it 'returns successful status' do
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

  describe 'GET #edit' do
    it 'returns successful status' do
      get :edit, params: { id: user.id }

      expect(response).to have_http_status(:ok)
    end

    it 'assigns the correct user to @user' do
      get :edit, params: { id: user.id }

      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'PATCH #update' do
    let(:updated_attributes) { { name: "Updated User", email: "updated.user@codeminer42.com" } }

    context 'with valid attributes' do
      it 'updates the user' do
        patch :update, params: { id: user.id, user: updated_attributes }

        user.reload
        expect(user.name).to eq("Updated User")
        expect(user.email).to eq("updated.user@codeminer42.com")
      end

      it 'redirects to user show page' do
        patch :update, params: { id: user.id, user: updated_attributes }

        expect(response).to redirect_to(new_admin_admin_user_path(user))
      end
    end

    context 'with invalid attributes' do
      it 'does not update the user' do
        invalid_attributes = { name: "", email: "invalid_email" }

        patch :update, params: { id: user.id, user: invalid_attributes }

        user.reload
        expect(user.name).not_to eq("")
        expect(user.email).not_to eq("invalid_email")
      end

      it 'flashes error and redirects to edit user page' do
        invalid_attributes = { name: "", email: "invalid_email" }

        patch :update, params: { id: user.id, user: invalid_attributes }

        expect(flash[:alert]).to be_present
        expect(response).to redirect_to(edit_new_admin_admin_user_path(user))
      end
    end
  end
end
