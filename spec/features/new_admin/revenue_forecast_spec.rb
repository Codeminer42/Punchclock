# frozen_string_literal: true

require 'rails_helper'

describe 'RevenueForecast', type: :feature do
  let(:admin_user) { create(:user, :admin, occupation: :administrative) }

  before do
    travel_to Date.parse('2023-08-01')
    sign_in(admin_user)
  end

  describe 'index' do
    context 'when allocations are present' do
      let(:developer) { create(:user).decorate }

      let!(:allocation) do
        create(:allocation,
               start_at: 2.months.after,
               end_at: 3.months.after,
               user: developer,
               ongoing: true).decorate
      end

      before { visit '/new_admin/revenue_forecast' }

      xit 'shows year of newest allocation' do
        within '#revenue_forecast_years' do
          expect(page).to have_button('2022') && have_button('2023')
        end
      end

      xit 'shows project details' do
        within '#revenue_forecast_years' do
          click_button '2023'
        end

        within '#revenue_forecast_index' do
          expect(page).to have_css('tbody tr', count: 4) &&
                          have_content(allocation.project.decorate.truncated_name)
        end
      end
    end
  end
end
