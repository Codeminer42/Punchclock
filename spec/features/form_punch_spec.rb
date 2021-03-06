# frozen_string_literal: true

require 'rails_helper'

feature 'Punches filter form' do
  let!(:company) { create(:company) }

  let!(:user) { create_logged_in_user(company_id: company.id) }

  let!(:project) { create(:project, company_id: company.id) }
  let!(:punch) { create(:punch, user_id: user.id, company_id: company.id) }

  let!(:user1) { create(:user, company_id: company.id) }
  let!(:user2) { create(:user, company_id: company.id) }
  let!(:user3) { create(:user, company_id: company.id) }

  background do
    create_list(:punch, 3, user: user1, company_id: company.id)
    create_list(:punch, 2, user: user2, company_id: company.id)
    create_list(:punch, 4, user: user3, company_id: company.id)
  end

  def click_on_filter
    click_button I18n.t(:create, scope: %i(helpers submit punches_filter_form))
  end

  context 'when the user is a regular user' do
    let!(:user) { create_logged_in_user(company_id: company.id) }

    scenario 'the user filter field is not present' do
      visit '/'
      expect(page).to_not have_selector 'punches_filter_form[user_id]'
    end
  end

  context 'date filters' do
    let!(:user) { create_logged_in_user(company_id: company.id) }

    scenario "filling only the 'since' field" do
      visit '/'

      within('#new_punches_filter_form') do
        fill_in 'punches_filter_form_since', with: '19/02/2014'
      end

      click_on_filter
    end

    scenario "filling only the 'until' field" do
      visit '/'

      within('#new_punches_filter_form') do
        fill_in 'punches_filter_form_until', with: '19/02/2014'
      end

      click_on_filter
    end

    scenario "filling both the 'until' and 'since' fields" do
      visit '/'

      within('#new_punches_filter_form') do
        fill_in 'punches_filter_form_since', with: '2014-02-01'
      end
    end
  end
end
