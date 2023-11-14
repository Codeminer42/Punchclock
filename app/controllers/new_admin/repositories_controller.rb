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
  end
end
