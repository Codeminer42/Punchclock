require 'spec_helper'

feature 'Add new Punch' do
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
      fill_in 'punch[when_day]', with: '2001-01-05'
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
      fill_in 'punch[when_day]', with: '2001-01-05'
      select active_project.name, from: 'punch[project_id]'
      click_button 'Criar Punch'
    end
    expect(page).to have_content('Punch não pôde ser criado.')
  end

  context 'creating punch with national and regional holidays' do
    let(:company) { create(:company) }
    let(:regional_holiday) { create(:regional_holiday, company: company) }
    let(:office) { create(:office, company: company) }
    let!(:user) { create(:user, company: company, office: office) }

    scenario 'test' do    
      visit '/punches/new'
      expect(page).to have_content I18n.t(
        :creating, scope: %i(helpers actions), model: Punch.model_name.human
      )

      within '#new_punch' do
        fill_in 'punch[from_time]', with: '08:00'
        fill_in 'punch[to_time]', with: '12:00'
        national = find('#punch_when_day')['data-national-holidays']
        regional = find('#punch_when_day')['data-regional-holidays']
        expect(national).to eq("[[1,1],[2,13],[3,30],[4,1],[4,21],[5,1],[5,31],[9,7],[10,12],[11,2],[11,15],[12,25]]")
        expect(regional).to eq("[]")
        click_button 'Criar Punch'
      end
    end
  end

  context 'creating punch without regional holidays' do
    let!(:user) { create(:user, :without_office) }

    scenario 'test 2' do
      visit '/punches/new'
      expect(page).to have_content I18n.t(
        :creating, scope: %i(helpers actions), model: Punch.model_name.human
      )

      within '#new_punch' do
        fill_in 'punch[from_time]', with: '08:00'
        fill_in 'punch[to_time]', with: '12:00'
        national = find('#punch_when_day')['data-national-holidays']
        regional = find('#punch_when_day')['data-regional-holidays']
        expect(national).to eq("[[1,1],[2,13],[3,30],[4,1],[4,21],[5,1],[5,31],[9,7],[10,12],[11,2],[11,15],[12,25]]")
        expect(regional).to eq("[]")
        click_button 'Criar Punch'
      end
    end
  end

  scenario 'select box without inactive project' do
    visit '/punches/new'
    expect(page).to_not have_select 'punch[project_id]', with_options: [inactive_project.name]
  end
end
