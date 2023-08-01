# frozen_string_literal: true

require 'rails_helper'

describe 'Projects', type: :feature do
  let(:admin_user) { create(:user, :admin, occupation: :administrative) }

  before { sign_in(admin_user) }

  describe 'Pagination' do
    let!(:projects) { create_list(:project, 3) }
    let(:maximum_per_page) { 2 }

    before do
      visit "/new_admin/projects?per=#{maximum_per_page}"
    end

    it "displays the maximum projects in each page", :aggregate_failure do
      within_table 'index_table_projects' do
        expect(page).to have_css('tbody tr', count: maximum_per_page)
      end

      within '#pagination_projects' do
        click_link '2'
      end

      within_table 'index_table_projects' do
        expect(page).to have_css('tbody tr', count: 1)
      end
    end
  end

  describe 'Filters' do
    before do
      visit '/new_admin/projects'
    end

    context 'by name' do
      let!(:project1) { create(:project, name: 'FirstProject') }
      let!(:project2) { create(:project, name: 'SecondProject') }

      it 'shows filtered projects' do
        within '#filters_sidebar_section' do
          expect(page).to have_field('name')

          fill_in 'name', with: 'First'
          click_button 'Filtrar'
        end

        within_table 'index_table_projects' do
          expect(page).to have_css('tbody tr', count: 1) and
            have_selector("project_#{project1.id}", count: 1) and
            have_no_selector("project_#{project2.id}")
        end
      end
    end
  end
end
