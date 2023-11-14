# frozen_string_literal: true

require 'rails_helper'

describe 'Edit Talk', type: :feature do
  let!(:user) { create_logged_in_user }
  let!(:talk) { create(:talk, user_id: user.id) }

  context 'when editing a talk with valid params' do
    before do
      visit "/talks/#{talk.id}/edit"

      fill_in 'Nome do evento', with: 'RailsConf'
      click_button 'Salvar'
    end

    it 'updates the talk' do
      expect(page).to have_content('Palestra foi atualizado com sucesso.')
    end
  end

  context 'when editing a talk with invalid params' do
    before do
      visit "/talks/#{talk.id}/edit"
    end

    context 'when event name is blank' do
      before do
        fill_in 'Nome do evento', with: ''
        click_button 'Salvar'
      end

      it 'shows an error message' do
        expect(page).to have_content('Nome do evento não pode ficar em branco')
      end

      it 'does not update the talk' do
        expect(page).to have_content('Palestra não pôde ser atualizado')
      end
    end

    context 'when talk title is blank' do
      before do
        fill_in 'Título da palestra', with: ''
        click_button 'Salvar'
      end

      it 'shows an error message' do
        expect(page).to have_content('Título da palestra não pode ficar em branco')
      end

      it 'does not update the talk' do
        expect(page).to have_content('Palestra não pôde ser atualizado')
      end
    end

    context 'when date is blank' do
      before do
        fill_in 'Data', with: ''
        click_button 'Salvar'
      end

      it 'shows an error message' do
        expect(page).to have_content('Data não pode ficar em branco')
      end

      it 'does not update the talk' do
        expect(page).to have_content('Palestra não pôde ser atualizado')
      end
    end

    context 'when date is future date' do
      before do
        fill_in 'Data', with: 10.days.from_now
        click_button 'Salvar'
      end

      it 'shows an error message' do
        expect(page).to have_content('Data não pode ser um período futuro')
      end

      it 'does not update the talk' do
        expect(page).to have_content('Palestra não pôde ser atualizado')
      end
    end
  end
end
