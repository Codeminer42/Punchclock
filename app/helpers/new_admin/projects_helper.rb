module NewAdmin
  module ProjectsHelper
    def market_options_for_select
      Project.market.values.map do |project_value|
        [I18n.t("projects.market.#{project_value}"), project_value]
      end
    end

    def not_allocated_users_options_for_select
      User.not_allocated.order(:name).map do |user|
        [user.name, user.id]
      end
    end
  end
end
