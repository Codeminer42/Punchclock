class ProfessionalExperiencesController < ApplicationController
  before_action :authenticate_user!

  def index
    @professional_experiences = current_user.professional_experiences.page(params[:page]).per(params[:per])
  end

  def new
    @professional_experience = ProfessionalExperience.new
  end

  def create
    @professional_experience = current_user.professional_experiences.new(professional_experience_params)

    if @professional_experience.save
      redirect_to professional_experiences_path,
                  notice: I18n.t(:notice, scope: "flash.actions.create",
                                          resource_name: ProfessionalExperience.model_name.human)
    else
      flash_errors('create', ProfessionalExperience.model_name.human, error_message)
      render :new
    end
  end

  private

  def professional_experience_params
    params.require(:professional_experience).permit(:company, :position, :description, :responsabilities, :start_date,
                                                    :end_date)
  end

  def errors
    @professional_experience.errors.full_messages.join('. ')
  end

  def error_message
    I18n.t(:errors, scope: "flash", errors:)
  end
end
