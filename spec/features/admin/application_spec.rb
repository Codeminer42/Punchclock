# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ApplicationController', type: :feature do
  describe 'when a regular user' do
    let(:user) { create :user }

    before do
      sign_in(user)
    end

    it 'redirects the punches page' do
      expect(page).to have_content('Todos os projetos')
    end

    it 'does not redirect the admin page' do
      expect(page).not_to have_content('Painel Administrativo')
    end
  end

  describe 'when a admin user' do
    let(:admin_user) { create(:user, :admin, occupation: :administrative) }

    before do
      sign_in(admin_user)
    end

    it 'redirects the dashboard page' do
      expect(page).to have_content('Painel Administrativo')
    end

    it 'does not redirect the admin page' do
      expect(page).not_to have_content('Todos os projetoss')
    end
  end

  describe 'when access an URL and is not logged in' do
    let(:user) { create :user }

    it 'redirects to login page' do
      visit vacations_path

      expect(page).to have_content('Sign In')
    end

    it 'redirects to previous url after log in' do
      visit vacations_path

      sign_in(user)

      expect(page).to have_content('Solicitar Férias')
    end
  end

  describe 'when access a non GET url and is not logged in' do
    let(:user) { create :user }

    it 'redirects to punches page after log in' do
      page.driver.browser.post(vacations_path)

      sign_in(user)

      expect(page).to have_content('Todos os projetos')
    end
  end
end
