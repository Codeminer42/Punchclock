module NewAdmin
  class ContributionsController < NewAdminController
    load_and_authorize_resource

    def index
      @contributions = scoped_contributions
    end

    private

    def scoped_contributions
      Contribution.active_engineers
    end
  end
end
