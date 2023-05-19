# frozen_string_literal: true

module NewAdmin
  class PunchesController < ApplicationController
    layout "new_admin"

    def show
      @punch = Punch.find(params[:id]).decorate
    end
  end
end
