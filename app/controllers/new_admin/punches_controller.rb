# frozen_string_literal: true

module NewAdmin
  class PunchesController < NewAdminController
    def show
      @punch = Punch.find(params[:id]).decorate
      AbilityAdmin.new(current_user).authorize! :read, @punch
    end
  end
end
