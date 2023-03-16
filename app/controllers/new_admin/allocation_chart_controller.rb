# frozen_string_literal: true

module NewAdmin
  class AllocationChartController < ApplicationController
    layout "new_admin"

    def index
      allocations = AllocationsAndUnalocatedUsersQuery.new(Allocation).call

      @allocations = allocations.reduce([]) do |acc, allo|
        allocation = { :name => allo.user.first_and_last_name,
                       :project_name => allo.project ? allo.project.name : nil,
                       :level => decorated_user(allo).level,
                       :specialty => decorated_user(allo).specialty,
                       :english_evaluation => decorated_user(allo).english_level,
                       :skills => decorated_user(allo).skills,
                       :allocation_end_at => build_date(allo.end_at) }

        acc.push(allocation)
      end
    end

    private

    def decorated_user(allocation)
      UserDecorator.decorate(allocation.user)
    end

    def build_date(date)
      date ? date.to_time.strftime("%d/%m/%Y") : I18n.t('not_allocated')
    end
  end
end
