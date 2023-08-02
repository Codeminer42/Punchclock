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
    context 'when no filter is applied' do
      let!(:projects) { create_list(:project, 2) }

      before do
        visit '/new_admin/projects'
      end

      it 'shows all projects' do
        within_table 'index_table_projects' do
          expect(page).to have_css('tbody tr', count: 2)
        end
      end
    end

    context 'by name' do
      let!(:project1) { create(:project, name: 'FirstProject') }
      let!(:project2) { create(:project, name: 'SecondProject') }

      before do
        visit '/new_admin/projects'
      end

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

    context 'by market' do
      let!(:internal_project) { create(:project, :internal) }
      let!(:international_project) { create(:project, :international) }

      before do
        visit '/new_admin/projects'
      end

      it 'shows filtered projects' do
        within '#filters_sidebar_section' do
          expect(page).to have_select('market')

          select I18n.t('projects.market.international'), from: 'market'
          click_button 'Filtrar'
        end

        within_table 'index_table_projects' do
          expect(page).to have_css('tbody tr', count: 1) and
            have_selector("project_#{international_project.id}", count: 1) and
            have_no_selector("project_#{internal_project.id}")
        end
      end
    end

    context 'by operation' do
      let!(:active_project) { create(:project, :active) }
      let!(:inactive_project) { create(:project, :inactive) }

      before do
        visit '/new_admin/projects'
      end

      it 'shows filtered projects' do
        within '#filters_sidebar_section' do
          expect(page).to have_field('active')

          check 'active'
          click_button 'Filtrar'
        end

        within_table 'index_table_projects' do
          expect(page).to have_css('tbody tr', count: 1) and
            have_selector("project_#{active_project.id}", count: 1) and
            have_no_selector("project_#{inactive_project.id}")
        end
      end
    end
  end
end
