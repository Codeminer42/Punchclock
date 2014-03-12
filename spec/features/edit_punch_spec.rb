require 'spec_helper'

feature "Edit Punch" do
  let!(:authed_user) { create_logged_in_user }
  let!(:project) { FactoryGirl.create(:project, company_id: authed_user.company_id) }
  let!(:punch) { FactoryGirl.create(:punch, user_id: authed_user.id, company_id: authed_user.company_id) }

  scenario "editing punch" do
    visit "/punches/#{punch.id}/edit"
    expect(page).to have_content('Editing punch')

    within "#edit_punch_#{punch.id}" do
      fill_in 'punch[from_time]', with: '08:00'
      fill_in 'punch[to_time]', with: '12:00'
      fill_in 'punch[when_day]', with: '2001-01-01'
      select project.name, from: 'punch[project_id]'
      click_button 'Atualizar Punch'
    end
    expect(page).to have_content('Punch updated successfully!')
    end
end
