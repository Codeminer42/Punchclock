module ActiveAdmin::UsersHelper
  def grouped_users_by_active_status(company)
    company
      .users
      .order(name: :asc)
      .group_by(&:active)
      .map do |active, users|
        status = active ? 'Ativo' : 'Inativo'
        options = users.map { |user| [user.name, user.id] }

        [status, options]
      end
      .to_h
  end
end
