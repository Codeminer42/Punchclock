# frozen_string_literal: true

require 'rails_helper'

describe 'Projects', type: :feature do
  let(:admin_user) { create(:user, :admin, occupation: :administrative) }

  before { sign_in(admin_user) }

  describe 'Pagination' do
    let!(:vacations) { create_list(:vacation, 3, :ongoing) }
    let(:maximum_per_page) { 2 }

    before do
      visit "/new_admin/vacations?per=#{maximum_per_page}"
    end

    it "displays the maximum vacations in each page", :aggregate_failure do
      within_table 'index_table_vacations' do
        expect(page).to have_css('tbody tr', count: maximum_per_page)
      end

      within '#pagination_vacations' do
        click_link '2'
      end

      within_table 'index_table_vacations' do
        expect(page).to have_css('tbody tr', count: 1)
      end
    end
  end

  describe 'scopes' do
    let!(:vacations) { create_list(:vacation, 3, :ongoing) }
    let!(:pending_vacations) { create_list(:vacation, 2, :pending) }

    before do
      visit '/new_admin/vacations'
    end

    it 'displays vacations in each scope section' do
      within_table 'index_table_vacations' do
        expect(page).to have_css('tbody tr', count: 3)
      end

      within '#vacation_scopes' do
        click_link "#{I18n.t('vacations.scopes.pending')} (2)"
      end

      within_table 'index_table_vacations' do
        expect(page).to have_css('tbody tr', count: 2)
      end
    end
  end
end

