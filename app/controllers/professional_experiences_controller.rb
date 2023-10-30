class ProfessionalExperiencesController < ApplicationController
  before_action :authenticate_user!

  def index
    @professional_experiences = scoped_professional_experiences.page(params[:page]).per(params[:per])
  end

  def show
    @professional_experience = scoped_professional_experiences.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to '/404'
  end

  def new
    @professional_experience = ProfessionalExperience.new
  end

  def create
    @professional_experience = ProfessionalExperience.new(professional_experience_params)
    @professional_experience.user = current_user

    if @professional_experience.save
      redirect_to professional_experiences_path,
                  notice: I18n.t(:notice, scope: "flash.actions.create",
                                          resource_name: ProfessionalExperience.model_name.human)
    else
      flash_errors('create', ProfessionalExperience.model_name.human, error_message)
      render :new
    end
  end

  def edit
    @professional_experience = scoped_professional_experiences.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to '/404'
  end

  def update
    @professional_experience = scoped_professional_experiences.find(params[:id])
    @professional_experience.attributes = professional_experience_params

    if @professional_experience.save
      redirect_to professional_experience_path(@professional_experience.id),
                  notice: I18n.t(:notice, scope: "flash.actions.update",
                                          resource_name: ProfessionalExperience.model_name.human)
    else
      flash_errors('update', ProfessionalExperience.model_name.human, error_message)
      render :edit
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to '/404'
  end

  def destroy
    @professional_experience = scoped_professional_experiences.find(params[:id])
    @professional_experience.destroy
    redirect_to professional_experiences_path,
                notice: I18n.t(:notice, scope: "flash.actions.destroy",
                                        resource_name: ProfessionalExperience.model_name.human)
  rescue ActiveRecord::RecordNotFound
    redirect_to '/404'
  end

  private

  def professional_experience_params
    params.require(:professional_experience).permit(:company, :position, :description, :responsibilities, :start_date,
                                                    :end_date)
  end

  def errors
    @professional_experience.errors.full_messages.join('. ')
  end

  def error_message
    I18n.t(:errors, scope: "flash", errors:)
  end

  def scoped_professional_experiences
    current_user.professional_experiences
  end
end
