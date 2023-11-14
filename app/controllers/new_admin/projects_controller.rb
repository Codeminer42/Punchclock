# frozen_string_literal: true

module NewAdmin
  class ProjectsController < NewAdminController
    load_and_authorize_resource

    before_action :set_project, only: %i[show edit update destroy]

    def index
      @projects = paginate_record(projects)
    end

    def new
      @project = Project.new.decorate
    end

    def show
      @allocations = @project.allocations.decorate
      @revenue_forecast = project_revenue_forecast
    end

    def create
      @project = Project.new(project_params)

      if @project.save
        redirect_on_success new_admin_projects_path, message_scope: 'create'
      else
        render_on_failure :new
      end
    end

    def edit; end

    def update
      if @project.update(project_params)
        redirect_on_success new_admin_show_project_path(id: @project.id), message_scope: 'update'
      else
        render_on_failure :edit
      end
    end

    private

    def project_revenue_forecast
      RevenueForecastService.project_forecast(@project)
    end

    def redirect_on_success(url, message_scope:)
      flash[:notice] = I18n.t(:notice, scope: "flash.actions.#{message_scope}",
                                       resource_name: Project.model_name.human)
      redirect_to url
    end

    def render_on_failure(template)
      flash.now[:alert] = @project.errors.full_messages.to_sentence
      render template, status: :unprocessable_entity
    end

    def project_params
      params.require(:project).permit(:name, :market, :active)
    end

    def projects
      ProjectsQuery.call filters
    end

    def filters
      params.extract!(
        :name,
        :market,
        :active
      )
    end

    def set_project
      @project = Project.find(params[:id]).decorate
    end
  end
end
