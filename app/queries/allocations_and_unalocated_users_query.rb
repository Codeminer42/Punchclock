# frozen_string_literal: true

class AllocationsAndUnalocatedUsersQuery
  attr_reader :allocation, :company

  def initialize(allocation, company)
    @allocation = allocation
    @company = company
  end

  def call
    allocation
      .includes(:user)
      .select('allocations.*, users.id as user_id')
      .joins(
        'RIGHT OUTER JOIN users ON allocations.user_id = users.id AND
        (allocations.end_at > NOW() OR allocations.end_at IS NULL)'
      )
      .where(where)
      .order('end_at NULLS LAST, start_at NULLS LAST, users.name')
  end

  private

  def where
    {
      end_at: [last_user_allocations, nil],
      users: { occupation: User.occupation.engineer.value, company: company, active: true },
      company: [company, nil]
    }
  end

  def last_user_allocations
    Allocation.group(:user_id).maximum(:end_at).values
  end
end
