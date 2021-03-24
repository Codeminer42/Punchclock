require 'rails_helper'

feature 'Edit User' do
  let!(:authed_user) { create_logged_in_user }

  before do
    visit '/user/edit'
  end

  describe 'with valid info' do
    it 'should update the name' do
      within "#edit_user_#{authed_user.id}" do
        fill_in 'user[name]', with: "#{authed_user.name} Sneak"

        click_button 'Atualizar Usuário'
      end

      expect(page).to have_content('User updated')
      expect(page).to have_content("#{authed_user.name} Sneak")
    end

    it 'should update the email' do
      within "#edit_user_#{authed_user.id}" do
        fill_in 'user[email]', with: "example@codeminer.com"

        click_button 'Atualizar Usuário'
      end

      expect(page).to have_content('User updated')
    end
  end

  describe 'with invalid info' do
    it 'should not update the email' do
      within "#edit_user_#{authed_user.id}" do
        fill_in 'user[email]', with: "example@"
  
        click_button 'Atualizar Usuário'
      end
  
      expect(page).to have_content('E-mail não é válido')
    end
  end

  describe 'Enabling two factor authentication' do
    it 'open the QR code page' do
      find('#activate-2fa-button').click

      expect(page).to have_content('Escaneie seu QR code com um aplicativo de autenticação antes de sair desta página.')
      expect(page).to have_content('Este codigo é único e só será mostrado esta vez.')
      expect(page).to have_css('.secret-string', text: authed_user.otp_secret)
    end
  end

  describe 'when having 2FA enabled' do

    before do
      enable_2fa_to_user(authed_user)
  
      visit '/user/edit'  
    end

    it 'generates 5 backup codes' do
      find('#generate-backup-codes').click

      expect(page).to have_css('#backup-codes-list .backup-code', :count => 5)
    end

  end
  
  describe 'disabling 2FA' do
    before do
      enable_2fa_to_user(authed_user)

      visit '/user/edit'
    end
    
    it 'opens deactivation page' do
      find('#deactivate-2fa-button').click
  
      expect(page).to have_content('Desativando Autenticação em Dois Fatores...')
      expect(page).to have_content('Não recomendamos seguir em frente com isso. Mas se você deseja, confirme seu código uma última vez.')
    end

    it 'deactivates 2FA' do
      find('#deactivate-2fa-button').click

      fill_in 'otp_attempt', with: authed_user.current_otp
      click_button 'Confirmar'

      expect(page).to have_content('Autenticação de dois fatores desativada')
    end
  end


  def enable_2fa_to_user(user)
    user.otp_secret = user.class.generate_otp_secret
    user.otp_required_for_login = true
    user.save
  end
end