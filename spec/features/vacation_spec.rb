require 'rails_helper'

RSpec.describe 'RequestVacation', type: :feature do
  let!(:authed_user) { create_logged_in_user }

  it 'shows validation date for current location' do
    visit new_vacation_path

    within '#new_vacation' do
      travel_to Time.zone.local(2023, 03, 31) do
        Time.current.freeze
      
        fill_in 'vacation[start_date]', with: '01/03/2023'
        fill_in 'vacation[end_date]', with: '03/03/2023'
        click_button 'Solicitar Férias'
      end
    end

    expect(page).to have_content('Solicitação de férias não pôde ser criada. Erros: Data de início deve ser maior que 31/03/2023. Data de término deve ser maior que 09/03/2023')
  end
end
