class CompanyUsersCollectionQuery
  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  def call
    company_users_arrays = current_user.super_admin? ? User.engineer.active.order(:name).group_by(&:company) : current_user.company.users.engineer.active.order(:name).group_by(&:company)
    company_users_arrays.map { |company, users| [company, users.map { |user| [user.name, user.id] }] }
  end
end
