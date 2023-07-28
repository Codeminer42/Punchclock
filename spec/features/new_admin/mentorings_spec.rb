# frozen_string_literal: true

require 'rails_helper'

describe 'Mentorings', type: :feature do
  let(:admin_user) { create(:user, :admin, occupation: :administrative) }

  before { sign_in(admin_user) }

  describe 'Pagination' do
    let!(:mentor1) { create(:user) }
    let!(:mentee1) { create(:user, mentor: mentor1) }

    let!(:mentor2) { create(:user) }
    let!(:mentee2) { create(:user, mentor: mentor2) }

    let(:maximum_per_page) { 1 }

    before do
      visit "/new_admin/mentorings?per=#{maximum_per_page}"
    end

    it "displays the maximum mentorings in each page", :aggregate_failure do
      within_table 'index_table_mentorings' do
        expect(page).to have_css('tbody tr', count: maximum_per_page)
      end

      within '#pagination_mentorings' do
        click_link '2'
      end

      within_table 'index_table_mentorings' do
        expect(page).to have_css('tbody tr', count: 1)
      end
    end
  end
end
