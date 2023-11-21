# frozen_string_literal: true

module NewAdmin
  class RevenueForecastController < NewAdminController
    authorize_resource class: false

    def index
      respond_to do |format|
        format.html do
          @years_range = RevenueForecastPresenter.years_range
        end

        format.xlsx do
          spreadsheet = DetailedMonthForecastSpreadsheet.new RevenueForecastService.detailed_month_forecast(
            params[:month].to_i, params[:year].to_i
          )
          send_data spreadsheet.to_string_io, filename: 'month_forecast.xlsx'
        rescue Date::Error
          flash[:alert] = I18n.t('not_possible_to_download_excel')
          redirect_to new_admin_revenue_forecast_index_path
        end
      end
    end
  end
end
