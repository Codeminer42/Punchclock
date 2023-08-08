# frozen_string_literal: true

module NewAdmin
  class ProjectsQuery
    def initialize(filters)
      self.filters = filters
    end

    def self.call(*args)
      new(*args).call
    end

    def call
      retrieve_projects
    end

    private

    attr_accessor :filters

    def retrieve_projects
      Project.includes(:allocations)
             .order(name: :asc)
             .by_market(filters[:market])
             .by_operation(filters[:active])
             .by_name_like(filters[:name])
    end
  end
end
