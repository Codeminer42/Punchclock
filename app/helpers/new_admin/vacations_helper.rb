# frozen_string_literal: true

module NewAdmin
  module VacationsHelper
    def vacation_query_scopes
      %w[ongoing_and_scheduled pending approved denied finished cancelled all]
    end

    def scoped_active_class(scope)
      return if params[:scope].blank?

      params[:scope] == scope ? 'bg-primary-600' : 'bg-primary-400'
    end
  end
end
