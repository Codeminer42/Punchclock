# frozen_string_literal: true

module NewAdmin
  class AllocationChartController < ApplicationController
    layout "new_admin"

    def index
      allocations = AllocationsAndUnalocatedUsersQuery.new(Allocation).call

      @allocations = allocations.map { |allocation| decorated_allocation(allocation) }
    end

    private

    def decorated_allocation(allocation)
      AllocationChartDecorator.decorate(allocation)
    end
  end
end
