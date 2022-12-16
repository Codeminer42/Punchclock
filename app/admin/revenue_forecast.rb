# frozen_string_literal: true

ActiveAdmin.register_page 'Revenue Forecast' do
  menu label: proc { I18n.t('revenue_forecast') }, priority: 12

  content title: I18n.t('revenue_forecast') do
    panel I18n.t('revenue_forecast') do
      tabs do

        # TODO: Refactor
        # * Current year tab should be rendered active by default
        # * Only fetches year data when user selects the tab
        # * Improve how data is being rendered
        # * Improve i18n
        RevenueForecastPresenter.years_range.each do |year|
          tab year.to_s do
            para(I18n.t('revenue_forecast_warning'), style: 'color: red') if year == 2022

            h2 I18n.t('international_market')
            render 'forecasts_table', { forecast: RevenueForecastPresenter.new(year, :international) }

            br

            h2 I18n.t('internal_market')
            render 'forecasts_table', { forecast: RevenueForecastPresenter.new(year, :internal) }
          end # tab
        end

      end # tabs
    end # panel
  end # content
end
