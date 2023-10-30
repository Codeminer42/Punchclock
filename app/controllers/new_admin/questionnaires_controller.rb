module NewAdmin
  class QuestionnairesController < NewAdminController
    load_and_authorize_resource

    def index
      @questionnaires = paginate_record(questionnaires)
    end

    private

    def filters
      params.extract!(
        :title,
        :kind,
        :active,
        :created_at_from,
        :created_at_until
      )
    end

    def questionnaires
      QuestionnairesQuery.call filters
    end
  end
end
