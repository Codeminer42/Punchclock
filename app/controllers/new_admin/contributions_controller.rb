module NewAdmin
  class ContributionsController < NewAdminController
    load_and_authorize_resource

    def index
      @contributions = contributions
    end

    private

    def filters
      params.permit(
        :state,
        :user_id,
        :reviewed_at_from,
        :reviewed_at_until,
        :created_at_from,
        :created_at_until,
        :this_week,
        :last_week
      )
    end

    def contributions
      ContributionsQuery.call(filters)
    end
  end
end
