# frozen_string_literal: true

require 'rails_helper'

describe 'Add new Punch', type: :feature do
  include ActiveSupport::Testing::TimeHelpers

  let!(:authed_user) { create_logged_in_user }
  let!(:active_project) { create(:project, :active) }
  let!(:inactive_project) { create(:project, :inactive) }

  it 'creating punch' do
    visit '/punches/new'
    expect(page).to have_content I18n.t(
      :creating, scope: %i(helpers actions), model: Punch.model_name.human
      )

    within '#new_punch' do
      fill_in 'punch[from_time]', with: '08:00'
      fill_in 'punch[to_time]', with: '12:00'
      fill_in 'punch[when_day]', with: '10/05/2019'
      select active_project.name, from: 'punch[project_id]'
      click_button 'Criar Punch'
    end
    expect(page).to have_content('Punch foi criado com sucesso.')
  end

  it 'creating invalid punch' do
    visit '/punches/new'
    expect(page).to have_content I18n.t(
      :creating, scope: %i(helpers actions), model: Punch.model_name.human
      )

    within '#new_punch' do
      fill_in 'punch[from_time]', with: '12:00'
      fill_in 'punch[to_time]', with: '8:00'
      fill_in 'punch[when_day]', with: '10/05/2019'
      select active_project.name, from: 'punch[project_id]'
      click_button 'Criar Punch'
    end
    expect(page).to have_content('Punch não pôde ser criado.')
  end

  context 'creating punch with all city holidays' do
    let(:regional_holiday) { create(:regional_holiday) }
    let(:city) { create(:city, regional_holidays: [regional_holiday]) }
    let!(:user) { create_logged_in_user({ city: city }) }

    it 'add the city holidays in the calendar' do
      visit '/punches/new'

      within '#new_punch' do
        holidays = JSON.parse(find('#punch_when_day')['data-holidays']).map(&:symbolize_keys)
        expect(holidays).to match_array(user.holidays)
      end
    end
  end

  it 'select box without inactive project' do
    visit '/punches/new'
    expect(page).to_not have_select 'punch[project_id]', with_options: [inactive_project.name]
  end

  context 'when user is allowed to do overtime' do
    before do
      authed_user.toggle!(:allow_overtime)
    end

    it 'creating punch selecting a holiday' do
      travel_to Date.new(2019, 3, 10) do

        visit '/punches/new'

        fill_in 'punch[from_time]', with: DateTime.new(2019, 1, 1, 8)
        fill_in 'punch[to_time]', with: DateTime.new(2019, 1, 1, 12)

        select active_project.name, from: 'punch[project_id]'
        check 'punch[extra_hour]'

        # march 5th is holiday
        # selectale days are wraped within a tag, holidays elements are wrapped within span tag
        fill_in 'punch[when_day]', with: '05/03/2019'

        click_button 'Criar Punch'

        expect(page).to have_content('Punch foi criado com sucesso.')
      end
    end
  end
end
