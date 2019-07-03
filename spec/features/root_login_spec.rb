# frozen_string_literal: true

require 'rails_helper'

feature 'Login', type: :feature do

  context 'when user is not active'  do
    let(:inactive_user) { create(:user, active: false) }
    it 'show a error message' do
      sign_in(inactive_user)
      expect(page).to have_content "Conta desativada"
    end
  end

  context 'when user is super admim' do
    let(:super_user) { create(:user, :super_admin) }
    it 'login to /admin/dashboard' do
      sign_in(super_user)
      expect(current_path).to eq(admin_dashboard_path)
    end
  end

  context 'when user is admin' do
    let(:admin_user) { create(:user, :admin, occupation: :administrative) }
    it 'login to /admin/dashboard' do
      sign_in(admin_user)
      expect(current_path).to eq(admin_dashboard_path)
    end
  end

  context 'when user is admin and engineer' do
    let(:admin_user) { create(:user, :admin, occupation: :engineer) }
    it 'login to /admin/dashboard' do
      sign_in(admin_user)
      expect(current_path).to eq(root_path)
    end
  end

  context 'when user is normal' do
    let(:normal_user) { create(:user) }
    it 'login to Punchclock root page' do
      sign_in(normal_user)
      expect(current_path).to eq(root_path)
    end
  end
end
