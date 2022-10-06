# frozen_string_literal: true

require 'rails_helper'

describe 'Login', type: :feature do
  context 'when user is not active' do
    let(:inactive_user) { create(:user, active: false) }
    it 'show a error message' do
      sign_in(inactive_user)
      expect(page).to have_content 'Conta desativada'
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

  context 'when user is default' do
    let(:user) { create(:user) }
    it 'login to Punchclock root page' do
      sign_in(user)
      expect(current_path).to eq(root_path)
    end
  end

  describe 'when user has 2FA enabled' do
    let(:user) { create(:user) }

    before do
      user.otp_secret = user.class.generate_otp_secret
      user.otp_required_for_login = true
      user.save
    end
    
    context 'with valid information' do
      it 'login to Punchclock root page' do
        sign_in(user)
        expect(current_path).to eq(root_path)
      end
    end

    context 'with invalid information' do
      it 'do not login to Punchclock root ' do
        sign_in(user, otp: '000X00')

        expect(page).to have_content 'E-mail, senha ou código OTP inválidos.'
      end
    end

    context 'using backup codes' do
      let(:backup_codes) { get_backup_codes(user) }

      it 'should login with valid code' do
        sign_in(user, otp: backup_codes.first)

        expect(current_path).to eq(root_path)
      end

      it 'should not login with invalid code' do
        sign_in(user, otp: backup_codes.first)
        
        logout()

        sign_in(user, otp: backup_codes.first)

        expect(page).to have_content 'E-mail, senha ou código OTP inválidos.'
      end
    end
  end

  describe 'when user credentials are invalid' do
    context 'when user is not registered' do
      let(:invalid_user) { build(:user) }

      it 'does not login to Punchclock root ' do
        sign_in(invalid_user)

        expect(page).to have_content 'E-mail ou senha inválidos.'
        expect(page).to have_selector '#user_email.is-invalid'
        expect(page).to have_selector '#user_password.is-invalid'
      end
    end

    context 'when wrong password is given' do
      let(:user) { create(:user) }

      it 'does not login to Punchclock root ' do
        user.password = "Bad_Pass"
        sign_in(user)

        expect(page).to have_content 'E-mail, senha ou código OTP inválidos.'
        expect(page).to have_selector '#user_email.is-invalid'
        expect(page).to have_selector '#user_password.is-invalid'
      end
    end
  end

  def get_backup_codes(user)
    codes = user.generate_otp_backup_codes!
    user.save

    codes
  end
end
