# frozen_string_literal: true

module NewAdmin
  class PunchesController < NewAdminController
    load_and_authorize_resource

    def show
      @punch = Punch.find(params[:id]).decorate
    end
  end
end
