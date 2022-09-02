class UsersByCompanyQuery
  def initialize(company)
    @company = company
  end

  def active_engineers
    @company.users
            .engineer
            .active
            .order(:name)
  end
end
