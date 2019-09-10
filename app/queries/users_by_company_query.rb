class UsersByCompanyQuery
  def initialize(company)
    @company = company
  end

  def not_allocated_including(user = nil)
    @company.users
            .engineer
            .active
            .where.not(id: users_allocated_except(user.try(:id)))
            .order(:name)
  end

  private

  def users_allocated_except(user_id)
    Allocation.ongoing.where.not(user_id: user_id).pluck(:user_id)
  end
end
