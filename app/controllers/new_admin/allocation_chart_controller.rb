# frozen_string_literal: true

module NewAdmin
  class AllocationChartController < ApplicationController
    layout "new_admin"

    def index
      allocations = AllocationsAndUnalocatedUsersQuery.new(Allocation).call

      @allocations = allocations.decorate
    end
  end
end
