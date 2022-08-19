# frozen_string_literal: true

class AllocationsAndUnalocatedUsersQuery
  attr_reader :allocation, :company, :with_ongoing

  def initialize(allocation, company, with_ongoing: false)
    @allocation = allocation
    @company = company
    @with_ongoing = with_ongoing
  end

  def call
   query =  allocation
      .includes(:user)
      .select('allocations.*, users.id as user_id')
      
      joins_user(query).where(where)
      .order('end_at NULLS LAST, start_at NULLS LAST, users.name')
  end

  private

  def joins_user(query)
    query.joins(
        "RIGHT OUTER JOIN users ON allocations.user_id = users.id AND #{
        with_ongoing ? "allocations.ongoing = true" : "(allocations.end_at > NOW() OR allocations.end_at IS NULL)"
        }"
    )
  end

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
