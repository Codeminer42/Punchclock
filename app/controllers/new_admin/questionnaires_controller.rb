module NewAdmin
  class QuestionnairesController < ApplicationController
    include Pagination

    layout 'new_admin'

    before_action :authenticate_user!

    def index
      @questionnaires = Questionnaire.all
    end
  end
end