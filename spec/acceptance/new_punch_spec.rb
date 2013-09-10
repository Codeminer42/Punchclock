require 'spec_helper'

feature "Add new Punch" do
  let!(:authed_user) { create_logged_in_user }
  let!(:project) {
    Project.create(name:Faker::Internet.name, company_id: authed_user.company_id)
  }
  scenario "creating punch" do
    visit '/punches/new'
    expect(page).to have_content('New punch')
    within '#new_punch' do
      fill_in 'punch[from(4i)]', with: '8'
      fill_in 'punch[from(5i)]', with: '0'
      fill_in 'punch[to(4i)]', with: '12'
      fill_in 'punch[to(5i)]', with: '0'
      fill_in 'when_day', with: '2001-01-01'
      select project.name, from: 'punch[project_id]'
      click_button 'Create Punch'
    end
    expect(page).to have_content('Punch created successfully!')
  end
end
