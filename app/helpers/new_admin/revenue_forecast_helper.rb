# frozen_string_literal: true

module NewAdmin
  module RevenueForecastHelper
    def selector_data_tab_id(year)
      "revenue_forecast_#{year}"
    end

    def international_forecast(year)
      RevenueForecastPresenter.new(year, :international)
    end

    def internal_forecast(year)
      RevenueForecastPresenter.new(year, :internal)
    end
  end
end
