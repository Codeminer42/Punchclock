# frozen_string_literal: true

module NewAdmin
  class VacationsController < NewAdminController
    def index
      @vacations = paginate_record(vacations)

      AbilityAdmin.new(current_user).authorize! :read, Vacation
    end

    private

    def filters
      { scope: params[:scope] }
    end

    def vacations
      VacationsQuery.call(filters)
    end
  end
end
