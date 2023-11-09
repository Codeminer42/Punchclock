module NewAdmin
  class QuestionnairesController < ApplicationController
    include Pagination

    layout 'new_admin'

    load_and_authorize_resource

    before_action :authenticate_user!

    def index
      @questionnaires = paginate_record(questionnaires)
    end

    def new
      @questionnaire = Questionnaire.new
    end

    def show
      @questionnaire = Questionnaire.find(params[:id])
    end

    def create
      @questionnaire = Questionnaire.new(questionnaire_params)

      if @questionnaire.save
        redirect_on_success new_admin_questionnaires_path, message_scope: 'create'
      else
        render_on_failure :new
      end
    end

    def edit
      @questionnaire = Questionnaire.find(params[:id])
    end

    def update
      @questionnaire = Questionnaire.find(params[:id])

      if @questionnaire.update(questionnaire_params)
        redirect_on_success new_admin_show_questionnaire_path(id: @questionnaire.id), message_scope: 'update'
      else
        render_on_failure :edit
      end
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

    def questionnaire_params
      params.require(:questionnaire).permit(:title, :kind, :active, :description,
                                            questions_attributes: %i[title kind raw_answer_options _destroy id])
    end

    def redirect_on_success(url, message_scope:)
      flash[:notice] = I18n.t(:notice, scope: "flash.actions.#{message_scope}",
                                       resource_name: Questionnaire.model_name.human)
      redirect_to url
    end

    def render_on_failure(template)
      flash.now[:alert] = @questionnaire.errors.full_messages.to_sentence
      render template, status: :unprocessable_entity
    end
  end
end
