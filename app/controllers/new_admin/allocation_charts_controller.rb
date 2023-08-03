# frozen_string_literal: true

module NewAdmin
  class AllocationChartsController < ApplicationController
    include Pagination

    layout 'new_admin'

    before_action :authenticate_user!

    def index
      @allocations = paginate_record(allocations)

      AbilityAdmin.new(current_user).authorize! :read, :allocation_chart
    end

    private

    def allocations
      AllocationsAndUnallocatedUsersQuery.new(Allocation).call
    end
  end
end
