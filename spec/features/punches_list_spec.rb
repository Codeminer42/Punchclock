require 'spec_helper'

feature "Punches list" do
  let!(:authed_user) { create_logged_in_user }
  let!(:punch) { FactoryGirl.create(:punch, :user_id => authed_user.id, company_id: authed_user.company_id) }
  let!(:other_project) { FactoryGirl.create(:project, company: authed_user.company) }

  before do
    visit '/punches'
    expect(page).to have_selector('.btn-primary[href="/punches/new"]')
    expect(page).to have_selector('.table-striped')
    expect(page).to have_content('TOTAL:')
  end

  scenario "follow show link" do
    click_link "shw-#{punch.id}"
    d1 = I18n.localize(punch.from, format: '%Y-%m-%d')
    d2 = I18n.localize(punch.from, format: '%H:%M')
    d3 = I18n.localize(punch.to, format: '%H:%M')
    expect(page).to have_content("#{d1} from #{d2} to #{d3}")
    expect(page).to have_content(punch.project.name)
    expect(page).to have_content(authed_user.name)
  end

  scenario "follow edit link" do
    click_link "edt-#{punch.id}"
    expect(page).to have_content('Editing punch')
  end

  scenario "follow destroy link" do
    click_link "dlt-#{punch.id}"
    expect(page).to have_content("Punch foi deletado com sucesso.")
  end

  scenario "sort punches" do
    click_link "Project"
    expect(page).to have_content('Project ▲')
  end

  scenario "filter punches" do
    fill_in 'punches_filter_form_since', with: '2014-01-17'
    fill_in 'punches_filter_form_until', with: '2014-01-20'
    select other_project.name, from: 'punches_filter_form_project_id'
    click_button 'Filtrar'
    expect(page).to have_content('0:00')
  end
end
