# frozen_string_literal: true

require 'rails_helper'

describe 'Projects', type: :feature do
  let(:admin_user) { create(:user, :admin, occupation: :administrative) }

  before do
    travel_to Date.parse('01/07/2023')
    sign_in(admin_user)
  end

  after { travel_back }

  describe 'index' do
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

  describe 'new' do
    before do
      visit '/new_admin/projects/new'
    end

    it 'shows form fields' do
      within "#form_project" do
        expect(page).to have_content(Project.human_attribute_name('name')) &&
                        have_content(Project.human_attribute_name('market')) &&
                        have_content(Project.human_attribute_name('active'))
      end

      expect(page).to have_button(I18n.t('form.button.submit'))
    end

    it 'creates project' do
      within "#form_project" do
        fill_in 'project_name', with: 'Foobar Project'
        select I18n.t('projects.market.international'), from: 'project_market'
        check 'project_active'
      end

      click_button I18n.t('form.button.submit')

      expect(page).to have_content(
        I18n.t(:notice, scope: "flash.actions.create", resource_name: Project.model_name.human)
      )
    end
  end

  describe 'show' do
    let(:project) { create(:project, name: 'Foobar') }

    before do
      visit "/new_admin/projects/#{project.id}"
    end

    it "shows project's details" do
      within "#details_table_projects" do
        expect(page).to have_css('tbody tr', count: 5) &&
                        have_content(project.name) &&
                        have_content(project.market) &&
                        have_content(project.id)
      end
    end

    it "shows actions for project" do
      within "#project_actions" do
        expect(page).to have_link(I18n.t('new_admin.projects.show.edit'))
      end
    end

    context 'when user clicks on create allocations button' do
      it 'redirects to allocate users to project page' do
        within '#project_allocate_user_action' do
          click_link I18n.t('allocate_users')
        end

        expect(page).to have_select('allocation_user_id') &&
                        have_field('allocation_start_at') &&
                        have_field('allocation_end_at')
      end
    end

    context 'when project has allocations' do
      let!(:allocation) do
        create(:allocation,
               start_at: 2.months.after,
               end_at: 3.months.after,
               user: create(:user),
               project:).decorate
      end

      before do
        visit "/new_admin/projects/#{project.id}"
      end

      it 'shows allocation details' do
        within '#allocations_table_projects' do
          expect(page).to have_css('tbody tr', count: 1) &&
                          have_content(allocation.user_name) &&
                          have_content(l(allocation.start_at, format: :long)) &&
                          have_content(l(allocation.end_at, format: :long)) &&
                          have_link(I18n.t('view'))
        end
      end

      it 'shows revenue forecast years buttons' do
        within '#project_revenue_forecast_years' do
          expect(page).to have_button(allocation.start_at.year.to_s)
        end
      end

      it 'creates paragraph for each month' do
        within '#project_revenue_forecast_index' do
          expect(page).to have_css('p', count: 12)
        end
      end

      it 'creates span for each revenue' do
        within '#project_revenue_forecast_index' do
          expect(page).to have_css('span', count: 12) &&
                          have_content('R$')
        end
      end
    end
  end

  describe 'edit' do
    let!(:project) { create(:project, :active, :international) }

    before do
      visit "/new_admin/projects/#{project.id}/edit"
    end

    it "shows form fields" do
      within "#form_project" do
        expect(page).to have_content(Project.human_attribute_name('name')) &&
                        have_content(Project.human_attribute_name('market')) &&
                        have_content(Project.human_attribute_name('active')) &&
                        have_selector('#project_market') &&
                        have_select('project_market', selected: project.decorate.market)
      end

      expect(page).to have_button(I18n.t('form.button.submit'))
    end

    it 'updates project', :aggregate_failures do
      new_name = 'Foobar Project'

      within "#form_project" do
        fill_in 'project_name', with: new_name
        select I18n.t('projects.market.internal'), from: 'project_market'
        uncheck 'project_active'
      end

      click_button I18n.t('form.button.submit')

      expect(page).to have_content(
        I18n.t(:notice, scope: "flash.actions.update",
                        resource_name: Project.model_name.human)
      )
      expect(project.reload.name).to eq(new_name)
      expect(project.reload.active).to be_falsey
      expect(project.reload.market).to be_internal
    end
  end
end
