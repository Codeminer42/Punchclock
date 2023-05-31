# frozen_string_literal: true

class AllocationsAndUnalocatedUsersQuery
  attr_reader :allocation

  def initialize(allocation)
    @allocation = allocation
  end

  def call
    allocation
      .includes(:user, :project, user: [:skills]) # TODO: We still have a N+1 issue with the last english evaluation column
      .select('allocations.*, users.id as user_id')
      .joins(
        "RIGHT OUTER JOIN users ON allocations.user_id = users.id AND allocations.ongoing = true"
      )
      .where(where)
      .order('end_at NULLS LAST, start_at NULLS LAST, users.name')
  end

  private

  def where
    {
      end_at: [last_user_allocations, nil],
      users: { occupation: User.occupation.engineer.value, active: true }
    }
  end

  def last_user_allocations
    Allocation.ongoing.group(:user_id, :start_at).maximum(:end_at).values
  end
end
