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

        expect(page).to have_selector('.dropdown-toggle', text: t('refills.navigation.my_resume'))
        click_link t('refills.navigation.my_resume')
        click_link t('activerecord.models.education_experience.one')
        expect(current_path).to eq(education_experiences_path)
      end
    end
  end
end
