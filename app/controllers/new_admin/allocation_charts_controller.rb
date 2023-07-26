# frozen_string_literal: true

module NewAdmin
  class AllocationChartsController < ApplicationController
    layout 'new_admin'

    before_action :authenticate_user!

    def index
      @allocations = AllocationsAndUnallocatedUsersQuery.new(Allocation).call.decorate
      AbilityAdmin.new(current_user).authorize! :read, :allocation_chart
    end
  end
end
