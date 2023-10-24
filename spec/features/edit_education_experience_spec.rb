# frozen_string_literal: true

require 'rails_helper'

describe 'Edit Education Experience', type: :feature do
  let!(:authed_user) { create_logged_in_user }
  let!(:education_experience) { create(:education_experience, user_id: authed_user.id) }

  context 'editing an education experience with valid params' do
    before do
      visit "/education_experiences/#{education_experience.id}/edit"
      fill_in t('activerecord.attributes.education_experience.institution'), with: 'USP'
      click_button t('education_experiences.form.save')
    end

    it 'updates the education experience' do
      expect(page).to have_content(t('flash.education_experience.update.notice'))
    end
  end

  context 'editing an education experience with invalid params' do
    before do
      visit "/education_experiences/#{education_experience.id}/edit"
      fill_in t('activerecord.attributes.education_experience.institution'), with: ''
      click_button t('education_experiences.form.save')
    end

    it 'does not creates a new education experience' do
      expect(page).to have_content(t('flash.education_experience.update.alert'))
    end
  end
end
