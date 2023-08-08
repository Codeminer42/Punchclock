# frozen_string_literal: true

module NewAdmin
  class VacationsController < ApplicationController
    layout 'new_admin'

    before_action :authenticate_user!

    def index
      @vacations = Vacation.all

      AbilityAdmin.new(current_user).authorize! :manage, Vacation
    end
  end
end
