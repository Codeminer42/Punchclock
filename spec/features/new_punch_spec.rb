require 'spec_helper'

feature "Add new Punch" do
  let!(:authed_user) { create_logged_in_user }
  let!(:project) {
    Project.create(name:Faker::Internet.name, company_id: authed_user.company_id)
  }
  scenario "creating punch" do
    visit '/punches/new'
    expect(page).to have_content('New Punch')
    within '#new_punch' do
      fill_in 'punch[from_time]', with: '08:00'
      fill_in 'punch[to_time]', with: '12:00'
      fill_in 'punch[when_day]', with: '2001-01-01'
      select project.name, from: 'punch[project_id]'
      click_button 'Criar Punch'
    end
    expect(page).to have_content('Punch created successfully!')
  end
end
