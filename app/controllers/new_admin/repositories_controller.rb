module NewAdmin
  class RepositoriesController < NewAdminController
    load_and_authorize_resource

    def index
      @repositories = paginate_record(repositories)
    end

    def show
      @repository = Repository.find(params[:id]).decorate
    end

    def new
      @repository = Repository.new
    end

    def create
      @repository = Repository.new(repository_params)

      if @repository.save
        redirect_on_success new_admin_repositories_path, message_scope: 'create'
      else
        render_on_failure :new
      end
    end

    def edit
      @repository = Repository.find(params[:id])
    end

    def update
      @repository = Repository.find(params[:id])

      @repository.attributes = repository_params

      if @repository.save
        redirect_on_success new_admin_show_repository_path(id: @repository.id), message_scope: 'update'
      else
        render_on_failure :edit
      end
    end

    def destroy
      @repository = Repository.find(params[:id])

      if @repository.destroy
        redirect_on_success new_admin_repositories_path, message_scope: "destroy"
      else
        render_on_failure :index
      end
    end

    private

    def repositories
      NewAdmin::RepositoryQuery.new(**filter_params).call
    end

    def repository_params
      params.require(:repository).permit(:link, :language, :description, :highlight)
    end

    def filter_params
      params.permit(:repository_name_search, languages: []).to_h.symbolize_keys
    end

    def redirect_on_success(url, message_scope:)
      flash[:notice] = I18n.t(:notice, scope: "flash.actions.#{message_scope}",
                                       resource_name: Repository.model_name.human)
      redirect_to url
    end

    def render_on_failure(template)
      flash.now[:alert] = @repository.errors.full_messages.to_sentence
      render template, status: :unprocessable_entity
    end

    def errors
      @repository.errors.full_messages.join('. ')
    end

    def error_message
      I18n.t(:errors, scope: :flash, errors:)
    end
  end
end
