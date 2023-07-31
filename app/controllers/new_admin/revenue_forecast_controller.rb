module NewAdmin
  class RevenueForecastController < ApplicationController
    layout 'new_admin'

    def index
      @years_range = RevenueForecastPresenter.years_range
    end
  end
end
