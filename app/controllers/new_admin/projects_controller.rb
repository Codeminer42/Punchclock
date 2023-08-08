# frozen_string_literal: true

module NewAdmin
  class ProjectsController < ApplicationController
    layout 'new_admin'

    include Pagination

    def index
      @projects = paginate_record(projects)
    end

    private

    def projects
      ProjectsQuery.call filters
    end

    def filters
      params.extract!(
        :name,
        :market,
        :active
      )
    end
  end
end
