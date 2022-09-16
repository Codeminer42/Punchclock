# frozen_string_literal: true

module ActiveAdmin
  module AllocationChartHelper
    class Status
      EXP_IN_60_DAYS = 'exp-in-60-days'
      EXP_IN_30_DAYS = 'exp-in-30-days'
      EXPIRED = 'expired'
      NOT_ALLOCATED = 'not-allocated'
      ALLOCATED = 'allocated'
    end

    def allocation_status_for(last_allocation:)
      return Status::NOT_ALLOCATED if last_allocation&.id.nil?

      end_date = last_allocation&.end_at
      return Status::ALLOCATED if end_date.nil?

      case end_date - Date.today
      when (61..)
        Status::ALLOCATED
      when 31..60
        Status::EXP_IN_60_DAYS
      when 1..30
        Status::EXP_IN_30_DAYS
      when -60..0
        Status::EXPIRED
      when (..-61)
        Status::NOT_ALLOCATED
      end
    end
  end
end
