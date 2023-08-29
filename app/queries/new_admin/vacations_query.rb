# frozen_string_literal: true

module NewAdmin
  class VacationsQuery
    DEFAULT_SCOPE = 'ongoing_and_scheduled'

    def initialize(filters)
      self.filters = filters
    end

    def self.call(*args)
      new(*args).call
    end

    def call
      retrieve_vacations_by_scope
    end

    private

    attr_accessor :filters

    def retrieve_vacations_by_scope
      Vacation.send(scope_filter)
    end

    def scope_filter
      filters[:scope].presence || DEFAULT_SCOPE
    end
  end
end
