require 'spec_helper'

feature "Punches filter form" do
  let!(:company) { FactoryGirl.create(:company) }

  let!(:user) { create_logged_in_user(company_id: company.id) }

  let!(:project) { FactoryGirl.create(:project, company_id: company.id) }
  let!(:punch) { FactoryGirl.create(:punch, user_id: user.id, company_id: company.id) }

  let!(:user1) { FactoryGirl.create(:user, company_id: company.id) }
  let!(:user2) { FactoryGirl.create(:user, company_id: company.id) }
  let!(:user3) { FactoryGirl.create(:user, company_id: company.id) }

  background do
    FactoryGirl.create_list(:punch, 3, user: user1, company_id: company.id)
    FactoryGirl.create_list(:punch, 2, user: user2, company_id: company.id)
    FactoryGirl.create_list(:punch, 4, user: user3, company_id: company.id)
  end

  context "when the user is admin" do
    let!(:user) { create_logged_in_user(is_admin: true, company_id: company.id) }

    scenario "the user filter field is present" do
      visit "/"

      within ("#filter-form") do
        select user.name, from: 'punches_filter_form[user_id]'
      end

      click_button 'Filtrar'
    end

    scenario "can filter the punches by a user" do
      visit "/"

      within ("#filter-form") do
        select user3.name, from: 'punches_filter_form[user_id]'
      end

      click_button 'Filtrar'
      expect(page).to have_selector ".user-punch", count: 4
    end
  end

  context "when the user is a regular user" do
    let!(:user) { create_logged_in_user(company_id: company.id)}

    scenario "the user filter field is not present" do
      visit "/"
      expect(page).to_not have_selector "punches_filter_form[user_id]"
    end
  end

  context "date filters" do
    let!(:user) { create_logged_in_user(company_id: company.id)}

    scenario "filling only the 'since' field" do
      visit "/"

      within ("#filter-form") do
        fill_in 'Until', with: '2014-02-19'
      end

      click_button 'Filtrar'
    end

    scenario "filling only the 'until' field" do
      visit "/"

      within ("#filter-form") do
        fill_in 'Until', with: '2014-02-19'
      end

      click_button 'Filtrar'
    end

    scenario "filling both the 'until' and 'since' fields" do
      visit "/"

      within ("#filter-form") do
        fill_in 'Since', with: '2014-02-01'
        fill_in 'Since', with: '2014-02-27'
      end

      click_button 'Filtrar'
    end
  end
end
