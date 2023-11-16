# frozen_string_literal: true

module NewAdmin
  class RevenueForecastController < NewAdminController
    authorize_resource class: false

    def index
      @years_range = RevenueForecastPresenter.years_range
    end
  end
end
