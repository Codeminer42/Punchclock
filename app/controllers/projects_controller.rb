class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!, only: :create

  def index
    @projects = end_of_chain.load
    respond_with @projects
  end

  def new
    @project = end_of_chain.build
    respond_with @project
  end

  def create
    @project = end_of_chain.create project_params
    respond_with @project, location: projects_path
  end

  def update
    @project = end_of_chain.find(params[:id])
    @project.update(project_params)
    respond_with @project, location: projects_path
  end

  private

  def ensure_admin!
    raise NotAuthorized unless current_user.is_admin?
  end

  def end_of_chain
    current_user.company.projects
  end

  def project_params
    params.require(:project).permit %w(name)
  end
end
