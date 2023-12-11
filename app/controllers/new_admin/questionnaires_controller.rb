module NewAdmin
  class QuestionnairesController < NewAdminController
    load_and_authorize_resource

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

      if @questionnaire.update(questionnaire_params) &&
        @questionnaire.questions.destroy_by(id: questions_to_be_destroyed_ids)
        redirect_on_success new_admin_show_questionnaire_path(id: @questionnaire.id), message_scope: 'update'
      else
        render_on_failure :edit
      end
    end

    def destroy
      @questionnaire = Questionnaire.find(params[:id])

      @questionnaire.destroy

      redirect_on_success new_admin_questionnaires_path, message_scope: 'destroy'
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

    def questions_to_be_destroyed_ids
      return nil unless questionnaire_params[:questions_attributes]
      ids = questionnaire_params[:questions_attributes].values.filter_map do |question|
        if question["_destroy"] != 'false'
          question["id"]
        end
      end
      ids
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
