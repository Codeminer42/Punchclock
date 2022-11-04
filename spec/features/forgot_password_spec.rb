# frozen_string_literal: true

require 'rails_helper'

describe 'Login', type: :feature do
  let(:user) { create(:user, name: 'Miner 42') }
  let(:mail) { NotificationMailer.notify_user_registration(user).deliver }

  context 'user forgot password' do
    it 'send forgot password mail', :aggregate_failures do
      visit '/'
      expect(page).to have_link('Esqueceu sua senha?')
      click_link('Esqueceu sua senha?')
      fill_in 'user[email]',  with: user.email.to_s
      click_button('Enviar as instruções para resetar a senha')
      expect(page).to have_text('Dentro de minutos, você receberá um e-mail com instruções para a troca da sua senha.')
    end

    it 'set new password', :aggregate_failures do
      expect(mail).to have_link('here')
      mail_link = mail.body.encoded.match(/(?:http?\:\/\/.*?)(\/.*?)(?=")/)
      visit mail_link
      expect(page).to have_text('Mude sua senha')
      fill_in 'user[password]',	with: '12345678'
      fill_in 'user[password_confirmation]',	with: '12345678'
      click_button('Mudar minha senha')
      expect(current_path).to eq(root_path)
    end
  end
end
