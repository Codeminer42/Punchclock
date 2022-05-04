require 'rails_helper'

RSpec.describe 'Oauth2', type: :feature do
  context 'when user is super admin' do
    let(:admin_user) { create(:user, :super_admin) }

    it 'back to oauth/authorize after login' do
      visit oauth_authorization_path
      sign_in(admin_user)
      expect(current_path).to eq(oauth_authorization_path)
    end

    it 'has access /oauth/applications' do
      sign_in(admin_user)
      visit oauth_applications_path
      expect(current_path).to eq(oauth_applications_path)
    end

    it 'has access to /oauth/authorized_applications' do
      sign_in(admin_user)
      visit oauth_authorized_applications_path
      expect(current_path).to eq(oauth_authorized_applications_path)
    end
  end

  context 'when user is admin' do
    let(:admin_user) { create(:user, :admin) }

    it 'back to oauth/authorize after login' do
      visit oauth_authorization_path
      sign_in(admin_user)
      expect(current_path).to eq(oauth_authorization_path)
    end

    it 'redirects to root when try to access /oauth/applications' do
      sign_in(admin_user)
      visit oauth_applications_path
      expect(current_path).to eq(root_path)
    end

    it 'has access to /oauth/authorized_applications' do
      sign_in(admin_user)
      visit oauth_authorized_applications_path
      expect(current_path).to eq(oauth_authorized_applications_path)
    end
  end

  context 'when user is normal' do
    let(:normal_user) { create(:user) }
    it 'back to oauth/authorize after login' do
      visit oauth_authorization_path
      sign_in(normal_user)
      expect(current_path).to eq(oauth_authorization_path)
    end

    it 'redirects to root when try to access /oauth/applications' do
      sign_in(normal_user)
      visit oauth_applications_path
      expect(current_path).to eq(root_path)
    end

    it 'has access to /oauth/authorized_applications' do
      sign_in(normal_user)
      visit oauth_authorized_applications_path
      expect(current_path).to eq(oauth_authorized_applications_path)
    end
  end
end
