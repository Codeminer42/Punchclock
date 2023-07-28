# frozen_string_literal: true

require 'rails_helper'

describe 'AllocationCharts', type: :feature do
  let(:admin_user) { create(:user, :admin, occupation: :administrative) }

  before { sign_in(admin_user) }

  describe 'Pagination' do
    let!(:allocations) { create_list(:allocation, 3) }
    let(:maximum_per_page) { 2 }

    before do
      visit "/new_admin/allocation_charts?per=#{maximum_per_page}"
    end

    it "displays the maximum allocations in each page", :aggregate_failure do
      within_table 'index_table_allocation_charts' do
        expect(page).to have_css('tbody tr', count: maximum_per_page)
      end

      within '#pagination_allocation_charts' do
        click_link '2'
      end

      within_table 'index_table_allocation_charts' do
        expect(page).to have_css('tbody tr', count: 1)
      end
    end
  end
end
