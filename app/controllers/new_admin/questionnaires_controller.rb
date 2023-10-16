module NewAdmin
  class QuestionnairesController < ApplicationController
    include Pagination

    layout 'new_admin'

    load_and_authorize_resource

    before_action :authenticate_user!

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
