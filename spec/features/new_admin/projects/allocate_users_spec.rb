# frozen_string_literal: true

require 'rails_helper'

describe 'NewAdmin::Projects::AllocateUsers', type: :feature do
  let(:admin_user) { create(:user, :admin, occupation: :administrative) }

  before { sign_in(admin_user) }

  describe 'new' do
    let!(:user) { create(:user) }
    let(:project) { create(:project) }

    before { visit "/new_admin/projects/allocate_users/new?allocation[project_id]=#{project.id}" }

    it 'shows form fields' do
      within "#form_project_allocate_user" do
        expect(page).to have_content(AllocateUsersForm.human_attribute_name('not_allocated_users')) &&
                        have_content(AllocateUsersForm.human_attribute_name('start_at')) &&
                        have_content(AllocateUsersForm.human_attribute_name('end_at'))
      end

      expect(page).to have_button(I18n.t('form.button.submit'))
    end

    it 'creates allocation' do
      within "#form_project_allocate_user" do
        select user.name, from: 'allocation_user_id'
        fill_in 'allocation_start_at', with: 1.month.ago
        fill_in 'allocation_end_at', with: 1.month.since
      end

      click_button I18n.t('form.button.submit')

      expect(page).to have_content(
        I18n.t(:notice, scope: "flash.actions.create", resource_name: Allocation.model_name.human)
      )
    end
  end
end
