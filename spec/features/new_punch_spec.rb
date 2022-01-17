# frozen_string_literal: true

require 'rails_helper'

feature 'Add new Punch' do
  include ActiveSupport::Testing::TimeHelpers

  let!(:authed_user) { create_logged_in_user }
  let!(:active_project) { create(:project, :active, company_id: authed_user.company_id) }
  let!(:inactive_project) { create(:project, :inactive, company_id: authed_user.company_id) }

  scenario 'creating punch' do
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

  scenario 'creating invalid punch' do
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

  context 'creating punch with all office holidays' do
    let(:company) { create(:company) }
    let(:regional_holiday) { create(:regional_holiday, company: company) }
    let(:office) { create(:office, company: company, regional_holidays: [regional_holiday]) }
    let!(:user) { create(:user, company: company, office: office) }

    scenario 'add the office hollidays in the calendar', :skip do
      visit '/punches/new'

      within '#new_punch' do
        holidays = JSON.parse(find('#punch_when_day')['data-holidays']).map(&:symbolize_keys)
        expect(holidays).to match_array(user.office_holidays)
      end
    end
  end

  scenario 'select box without inactive project' do
    visit '/punches/new'
    expect(page).to_not have_select 'punch[project_id]', with_options: [inactive_project.name]
  end

  context 'when user is allowed to do overtime', js: true do
    before do
      authed_user.toggle!(:allow_overtime)
    end

    scenario 'creating punch selecting a holiday' do
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
