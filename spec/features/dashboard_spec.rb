# frozen_string_literal: true

require 'rails_helper'

describe 'Punches Dashboard', type: :feature do
  context 'When user has overtime allowed' do
    let!(:authed_user_with_overtime) { create_logged_in_user(allow_overtime: true) }
    let!(:active_project) { create(:project, :active) }

    it 'Calendar navigation', js: true do
      visit '/dashboard/2014/12'

      expect(page).to have_content('December 2014')
      find('a', text: '❯').click
      expect(page).to have_content('January 2015')
      find('a', text: '❮').click
      expect(page).to have_content('December 2014')
    end

    it 'Insert and delete punches', js: true do
      visit '/dashboard/2013/10'

      find('td.inner', text: '10').click
      find('td.inner', text: '11').click
      find('span.select2').click
      find('li.select2-results__option').click
      click_on 'Salvar'
      expect(page).to have_content("Selecionado (0)")

      visit '/dashboard/2013/10'
      find('td.inner', text: '15').click
      find('button', text: 'Apagar').click
      expect(page).to have_content("Selecionado (0)")
    end

    it 'Insert punches on holiday', js: true do
      visit 'dashboard/2013/11'

      find('td.inner', text: '02').click
      find('td.inner', text: '15').click
      find('span.select2').click
      find('li.select2-results__option').click
      expect(page).to have_content("Selecionado (2)")
      click_on 'Salvar'
      expect(page).to have_content("Selecionado (0)")
    end

    it 'Multiple selection through sheets', js: true do
      visit '/dashboard/2018/01'

      find('td.inner', text: '19').click
      find('td.inner', text: '20').click
      expect(page).to have_content('Selecionado (2)')

      within 'tbody > tr:nth-child(3)' do
        expect(page).to have_css("td.selected", text: "19") & have_css("td.selected", text: "20")
      end

      find('td.inner', text: '21').click
      find('span.select2').click
      find('li.select2-results__option').click
      expect(page).to have_content('Selecionado (3)')
      click_on 'Salvar'
      expect(page).to have_content('Horas: 24')
    end

    it 'When no project has been selected', js: true do
      visit '/dashboard/2018/02'
      find('td.inner', text: '21').click
      expect(page).to have_button('Salvar', disabled: true)
    end
  end

  context 'When user do not have overtime allowed' do
    let!(:authed_user_without_overtime) { create_logged_in_user }
    let!(:active_project) { create(:project, :active) }

    it 'Insert punches on holiday', js: true do
      visit 'dashboard/2013/11'

      find('td.inner', text: '02').click
      find('td.inner', text: '03').click
      find('span.select2').click
      find('li.select2-results__option').click
      expect(page).to have_content("Selecionado (1)")

      accept_alert do
        click_on 'Salvar'
        expect(page).to have_content("Selecionado (0)")
      end
    end
  end

  context 'When user try to save a punch with delta zero' do
    let!(:authed_user_without_overtime) { create_logged_in_user }
    let!(:active_project) { create(:project, :active) }

    it 'Renders save button disabled', js: true do
      visit '/dashboard/2022/06'

      find('td.inner', text: '06').click
      find('span.select2').click
      find('li.select2-results__option').click

      hour_inputs = all('.form-control')

      morning_start_input = hour_inputs[0]
      morning_end_input = hour_inputs[1]

      lunch_start_input = hour_inputs[2]
      lunch_end_input = hour_inputs[3]

      morning_start_input.set('09:00')
      morning_end_input.set('12:00')   

      lunch_start_input.set('09:00')
      lunch_end_input.set('12:00')      

      save_button = find('.w-100')
      
      expect(save_button.disabled?).to eq(true)
    end
  end

  context 'When user try to save a punch in the future' do
    let!(:authed_user_without_overtime) { create_logged_in_user }
    let!(:active_project) { create(:project, :active) }
    let(:time_now) { Time.rfc3339('2022-06-06T15:00:00-03:00') }
    
    before do
      allow(Time).to receive(:now).and_return(time_now)
    end

    it 'Renders alert with error messages', js: true do
      visit '/dashboard/2022/06'
      
      find('td.inner', text: '06').click
      find('span.select2').click
      find('li.select2-results__option').click

      hour_inputs = all('.form-control')

      morning_start_input = hour_inputs[0]
      morning_end_input = hour_inputs[1]

      lunch_start_input = hour_inputs[2]
      lunch_end_input = hour_inputs[3]

      morning_start_input.set('09:00')
      morning_end_input.set('12:00')   

      lunch_start_input.set('13:00')
      lunch_end_input.set(1.hour.from_now.to_fs(:time))     

      alert_message = accept_alert { click_on 'Salvar' }
      
      expect(alert_message).to eq('Horário final não pode ser no futuro')
    end
  end
end
