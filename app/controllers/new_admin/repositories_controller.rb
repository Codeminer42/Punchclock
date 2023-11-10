module NewAdmin
  class RepositoriesController < NewAdminController
    include Pagination
    before_action :authenticate_user!
    load_and_authorize_resource

    layout 'new_admin'

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

    def current_ability
      AbilityAdmin.new(current_user)
    end
  end
end
