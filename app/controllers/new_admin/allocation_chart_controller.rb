# frozen_string_literal: true

module NewAdmin
  class AllocationChartController < ApplicationController
    layout "new_admin"

    def index
      @allocations = AllocationsAndUnalocatedUsersQuery.new(Allocation).call.decorate
    end
  end
end
