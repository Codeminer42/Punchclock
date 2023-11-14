# frozen_string_literal: true

module NewAdmin
  class VacationsController < NewAdminController
    load_and_authorize_resource

    def index
      @vacations = paginate_record(vacations)
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
