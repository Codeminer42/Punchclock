require 'spec_helper'

feature "Edit Punch" do
  let!(:authed_user) { create_logged_in_user }
  let!(:project) { FactoryGirl.create(:project, company_id: authed_user.company_id) }
  let!(:punch) { FactoryGirl.create(:punch, user_id: authed_user.id, company_id: authed_user.company_id) }

  scenario "editing punch" do
    visit "/punches/#{punch.id}/edit"
    expect(page).to have_content('Editing punch')
    within "#edit_punch_#{punch.id}" do
      fill_in 'punch[from(4i)]', with: '8'
      fill_in 'punch[from(5i)]', with: '0'
      fill_in 'punch[to(4i)]', with: '12'
      fill_in 'punch[to(5i)]', with: '0'
      fill_in 'when_day', with: '2001-01-01'
      select project.name, from: 'punch[project_id]'
      click_button 'Update Punch'
    end
    expect(page).to have_content('Punch updated successfully!')
  end
end
