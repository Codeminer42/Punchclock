# frozen_string_literal: true

module NewAdmin
  class RevenueForecastController < ApplicationController
    load_and_authorize_resource

    before_action :authenticate_user!

    layout 'new_admin'

    def index
      @years_range = RevenueForecastPresenter.years_range
    end
  end
end
