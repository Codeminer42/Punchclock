module NewAdmin
  class QuestionnairesController < ApplicationController
    include Pagination

    layout 'new_admin'

    load_and_authorize_resource

    before_action :authenticate_user!

    def index
      @questionnaires = Questionnaire.all
    end
  end
end

#TODO:
#Filtros no index
