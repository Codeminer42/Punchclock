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
          forecast = RevenueForecastPresenter.new(year)

          tab year.to_s do
            columns do
              column do
                para I18n.t('projects')

                forecast.projects.each do |project|
                  para project.name
                end
              end

              forecast.months do |month_name, forecasts, total|
                column do
                  para month_name

                  forecasts.each do |forecast|
                    para forecast
                  end

                  span total
                end # column
              end
            end # columns
          end # tab
        end

      end # tabs
    end # panel
  end # content
end
