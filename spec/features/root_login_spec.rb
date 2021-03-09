# frozen_string_literal: true

require 'rails_helper'

feature 'Login', type: :feature do
  context 'when user is not active' do
    let(:inactive_user) { create(:user, active: false) }
    it 'show a error message' do
      sign_in(inactive_user)
      expect(page).to have_content 'Conta desativada'
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

  context 'when user is open source manager' do
    let(:open_source_manager_user) { create(:user, :open_source_manager) }
    it 'login to /admin/dashboard' do
      sign_in(open_source_manager_user)
      expect(current_path).to eq(admin_dashboard_path)
    end
  end

  context 'when user is admin and engineer' do
    let(:admin_user) { create(:user, :admin, occupation: :engineer) }
    it 'login to /admin/dashboard' do
      sign_in(admin_user)
      expect(current_path).to eq(admin_dashboard_path)
    end
  end

  context 'when user is normal' do
    let(:normal_user) { create(:user) }
    it 'login to Punchclock root page' do
      sign_in(normal_user)
      expect(current_path).to eq(root_path)
    end
  end

  describe 'when user has 2FA enabled' do
    let(:normal_user) { create(:user) }

    before do
      normal_user.otp_secret = normal_user.class.generate_otp_secret
      normal_user.otp_required_for_login = true
      normal_user.save
    end
    
    context 'with valid information' do
      it 'login to Punchclock root page' do
        sign_in(normal_user)
        expect(current_path).to eq(root_path)
      end
    end

    context 'with invalid information' do
      it 'do not login to Punchclock root ' do
        sign_in(normal_user, otp: '000X00')

        expect(page).to have_content 'E-mail, senha ou código OTP inválidos.'
      end
    end
  end
end
