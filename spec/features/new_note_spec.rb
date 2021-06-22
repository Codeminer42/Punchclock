# frozen_string_literal: true

require 'rails_helper'

feature 'Add new note' do
  include ActiveSupport::Testing::TimeHelpers

  let!(:authed_admin_user) { create_logged_in_user role: 'admin' }
  let(:user_1) { create(:user) }

  scenario 'creates a note' do
    visit "/users/#{user_1.id}/notes/new"
    
    within '#new_note' do
      fill_in 'note[title]', with: 'Test note'
      fill_in 'note[comment]', with: 'Test comment'
      select "Good", from: 'note[rate]'
      
      click_button 'Criar Note'
    end

    expect(page).to have_content 'Note foi criado com sucesso.'
    expect(current_path).to eq evaluations_path
  end

  context 'when title is empty' do
    scenario 'does not creates a note' do
      visit "/users/#{user_1.id}/notes/new"
    
      within '#new_note' do
        fill_in 'note[title]', with: ''
        fill_in 'note[comment]', with: 'Test comment'
        
        click_button 'Criar Note'
      end

      expect(page).to have_content 'Note não pôde ser criado. Erros: Title não pode ficar em branco'
    end
  end

  context 'when comment is empty' do
    scenario 'does not creates a note' do
      visit "/users/#{user_1.id}/notes/new"
    
      within '#new_note' do
        fill_in 'note[title]', with: 'Test note'
        fill_in 'note[comment]', with: ''
        
        click_button 'Criar Note'
      end

      expect(page).to have_content 'Note não pôde ser criado. Erros: Comment não pode ficar em branco'
    end
  end
end
