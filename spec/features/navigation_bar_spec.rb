# frozen_string_literal: true

require 'rails_helper'

feature 'Navigation Bar' do
  describe 'Resume options' do
    let(:user) { create(:user) }

    context 'when the user is logged in' do
      before do
        sign_in user
      end

      it 'has the education experience dropdown option on the navigation bar', agreggate_failures: true do
        visit root_path

        expect(page).to have_selector('.dropdown-toggle', text: 'Meu currículo')
        click_link 'Meu currículo'
        click_link 'Experiência Educacional'
        expect(current_path).to eq(education_experiences_path)
      end
    end

    context 'when the user is not logged in', agreggate_failures: true do
      it 'does not show the education experience dropdown option on the navigation bar', agreggate_failures: true do
        visit root_path

        expect(page).not_to have_selector('.dropdown-toggle', text: 'Meu currículo')
      end
    end
  end
end
