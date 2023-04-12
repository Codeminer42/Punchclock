# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RequestVacation', type: :feature do
  let!(:authed_user) { create_logged_in_user }

  it 'shows validation date for current location' do
    visit new_vacation_path

    within '#new_vacation' do
      travel_to Time.zone.local(2023, 3, 31) do
        fill_in 'vacation[start_date]', with: '01/03/2023'
        fill_in 'vacation[end_date]', with: '03/03/2023'
        click_button 'Solicitar Férias'
      end
    end

    expect(page).to have_content('Solicitação de férias não pôde ser criada. Erros: Data de início deve ser maior que 31/03/2023. Data de término deve ser maior que 09/03/2023')
  end

  context 'when start date is close or in a holiday' do
    before do
      allow_any_instance_of(User).to receive(:office_holidays)
        .and_return([
                      {
                        day: Date.current.next_week(:wednesday).day,
                        month: Date.current.next_week(:wednesday).month
                      }
                    ])
    end

    it 'shows validation date for holidays' do
      visit new_vacation_path
      within '#new_vacation' do
        fill_in 'vacation[start_date]', with: Date.current.next_week(:monday)
        fill_in 'vacation[end_date]', with: Date.current.next_month
        click_button 'Solicitar Férias'
      end

      expect(page).to have_content('Solicitação de férias não pôde ser criada. Erros: Data de início O início das férias não pode ser próximo a um feriado')
    end
  end
end
