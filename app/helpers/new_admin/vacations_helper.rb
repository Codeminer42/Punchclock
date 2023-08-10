# frozen_string_literal: true

module NewAdmin
  module VacationsHelper
    ACTIVE_BUTTON_COLOR = 'bg-primary-600'
    INACTIVE_BUTTON_COLOR = 'bg-primary-400'

    def vacation_query_scopes
      %w[ongoing_and_scheduled pending approved denied finished cancelled all]
    end

    def scoped_active_class(scope)
      return ACTIVE_BUTTON_COLOR if no_scope_selected? scope

      params[:scope] == scope ? ACTIVE_BUTTON_COLOR : INACTIVE_BUTTON_COLOR
    end

    def vacation_scope_selector(scope)
      <<-SELECTOR.squish
        #{t("vacations.scopes.#{scope}")} (#{Vacation.send(scope).count})
      SELECTOR
    end

    private

    def no_scope_selected?(scope)
      scope == VacationsQuery::DEFAULT_SCOPE && params[:scope].blank?
    end
  end
end
