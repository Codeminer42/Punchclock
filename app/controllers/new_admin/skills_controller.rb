module NewAdmin
  class SkillsController < NewAdminController
    load_and_authorize_resource

    def index
      @skills = paginate_record(skills)
    end

    private

    def filters
      params.permit(
        :title
      )
    end

    def skills
      SkillsQuery.call filters
    end
  end
end
