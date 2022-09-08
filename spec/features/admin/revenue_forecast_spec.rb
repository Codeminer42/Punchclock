# frozen_string_literal: true

require 'rails_helper'

describe 'Revenue Forecast page', type: :feature do
  let(:admin_user) { create(:user, :admin, occupation: :administrative) }
  let(:company) { admin_user.company }
  let(:project1) { create(:project, company: company) }
  let(:project2) { create(:project, company: company) }

  before do
    create(:allocation, project: project1, company: company, hourly_rate: 100, start_at: Date.new(2022, 5, 1), end_at: Date.new(2022, 11, 1))
    create(:allocation, project: project2, company: company, hourly_rate: 50, start_at: Date.new(2021, 8, 1), end_at: Date.new(2022, 8, 31))

    sign_in(admin_user)
    visit '/admin/revenue_forecast'
  end

  it 'has tabs for each year of allocations' do
    aggregate_failures 'testing tabs' do
      expect(page).not_to have_text('2020')
      expect(page).to have_text('2021')
      expect(page).to have_text('2022')
      expect(page).not_to have_text('2023')
    end
  end

  it 'has columns headers with "Projetos" and all months names' do
    aggregate_failures 'testing columns headers' do
      expect(page).to have_text('Projetos')

      Date::MONTHNAMES[1..12].each do |name|
        expect(page).to have_text(name)
      end
    end
  end

  context 'on 2021 year tab' do
    it 'shows only revenue forecast from 2021' do
      within "div#2021" do
        # Projects names
        expect(page).not_to have_text(project1.name)
        expect(page).to have_text(project2.name)

        # Forecasts
        expect(page).not_to have_text("R$17.600,00")
        expect(page).to have_text("R$8.800,00")
        expect(page).not_to have_text("R$26.400,00")
      end
    end
  end

  context 'on 2022 year tab' do
    it 'shows only revenue forecast from 2022' do
      within "div#2022" do
        # Projects names
        expect(page).to have_text(project1.name)
        expect(page).to have_text(project2.name)

        # Forecasts
        expect(page).to have_text("R$17.600,00")
        expect(page).to have_text("R$8.800,00")
        expect(page).to have_text("R$26.400,00")
      end
    end
  end
end
