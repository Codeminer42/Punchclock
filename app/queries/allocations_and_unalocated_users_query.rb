class AllocationsAndUnalocatedUsersQuery
  class << self
    def call(company)
      Allocation.joins('RIGHT OUTER JOIN users ON allocations.user_id = users.id')
      .select('allocations.*, users.id as user_id')
      .where(end_at: [Allocation.group(:user_id).maximum(:end_at).values, nil],
        users: { occupation: User.occupation.engineer.value, company: company },
        company: [company, nil])
      .includes(:user)
      .order('end_at ASC NULLS FIRST, start_at ASC NULLS FIRST')
    end
  end
end
