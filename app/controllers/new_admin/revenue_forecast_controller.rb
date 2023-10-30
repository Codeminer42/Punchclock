# frozen_string_literal: true

module NewAdmin
  class RevenueForecastController < NewAdminController
    load_and_authorize_resource

    def index
      @years_range = RevenueForecastPresenter.years_range
    end
  end
end
