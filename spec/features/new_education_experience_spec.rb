# frozen_string_literal: true

require 'rails_helper'

describe 'Add new Education Experience', type: :feature do
  let!(:authed_user) { create_logged_in_user }

  it 'displays the new education experience message' do
    visit '/education_experiences/new'

    expect(page).to have_content('Nova experiência educacional')
  end

  it 'has the a link to create a new user experience' do
    visit '/education_experiences'

    expect(page).to have_link(t('education_experiences.new.new_experience'))
  end

  context 'creating a valid education experience' do
    before do
      visit '/education_experiences/new'
      within '#new_education_experience' do
        fill_in 'Instituição', with: 'USP'
        fill_in 'Curso', with: 'CC'
        fill_in "Data de início", with: '10/05/2019'
        fill_in "Data de término", with: '10/05/2020'
        click_button 'Salvar'
      end
    end

    it 'creates a new education experience' do
      expect(page).to have_content('Experiência educacional criada com sucesso.')
    end
  end

  context 'creating an invalid education experience' do
    before do
      visit '/education_experiences/new'
      within '#new_education_experience' do
        fill_in 'Instituição', with: 'USP'
        fill_in 'Curso', with: 'CC'
        fill_in "Data de início", with: '10/05/2019'
        fill_in "Data de término", with: '10/05/2015'
        click_button 'Salvar'
      end
    end

    it 'does not creates a new education experience' do
      expect(page).to have_content('A Experiência educacional não pôde ser criada.')
    end
  end
end
