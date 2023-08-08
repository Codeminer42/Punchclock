module NewAdmin
  module ProjectsHelper
    def market_options_for_select
      Project.market.values.map do |project_value|
        [I18n.t("projects.market.#{project_value}"), project_value]
      end
    end
  end
end
