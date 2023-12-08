module NewAdmin
  class RepositoriesController < NewAdminController
    load_and_authorize_resource

    def index
      @repositories = paginate_record(repositories)
    end

    def show
      @repository = Repository.find(params[:id]).decorate
    end

    private

    def repositories
      NewAdmin::RepositoryQuery.new(**filter_params).call
    end

    def filter_params
      params.permit(:repository_name_search, languages: []).to_h.symbolize_keys
    end
  end
end
