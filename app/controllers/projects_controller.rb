class ProjectsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource except: [:create]

  def index
    @projects = current_user.company.projects
  end

  def new
    @project = Project.new(company: current_user.company)
  end

  def create
    project = Project.new(project_params)
    project.company = current_user.company
    authorize! :create, project
    if project.save
      flash[:notice] = 'Project created successfully!'
      redirect_to projects_path
    else
      @project = project
      render action: :new
    end
  end

  def update
    if @project.update(project_params)
      redirect_to projects_path
    else
      render action: :edit
    end
  end

  private

  def project_params
    allow = [:name]
    params.require(:project).permit(allow)
  end
end
