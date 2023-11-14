# frozen_string_literal: true

module NewAdmin
  class AllocationChartsController < NewAdminController
    authorize_resource class: false

    def index
      @allocations = paginate_record(allocations)
    end

    private

    def allocations
      AllocationsAndUnallocatedUsersQuery.new(Allocation).call
    end
  end
end
