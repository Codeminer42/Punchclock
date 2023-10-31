# frozen_string_literal: true

class EducationExperiencesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do
    redirect_to '/404'
  end

  before_action :authenticate_user!

  def index
<<<<<<< HEAD
    @undecorated_experiences = EducationExperience.for_user(current_user.id)
    @education_experiences = EducationExperiencePaginationDecorator.new(params, @undecorated_experiences)
=======
    @education_experiences = PunchesPaginationDecorator.new(params, EducationExperience.where(user_id: current_user.id))
>>>>>>> 1aaaab0b (create education experiences index action)
  end

  def new
    @education_experience = EducationExperience.new
  end

  def create
    @education_experience = EducationExperience.new(education_experience_params)

    if @education_experience.save
      redirect_to education_experiences_path, notice: I18n.t(:notice, scope: "flash.education_experience.create")
    else
      flash_errors('create')
      render :new
    end
  end

  def edit
    @education_experience = current_user.education_experiences.find(params[:id])
  end

  def update
    @education_experience = current_user.education_experiences.find params[:id]

    if @education_experience.update(education_experience_params)
      redirect_to education_experiences_path, notice: I18n.t(:notice, scope: "flash.education_experience.update")
    else
      flash_errors('update')
      render :edit
    end
  end

  private

  def education_experience_params
    params.require(:education_experience).permit(:institution, :course, :start_date, :end_date, :user_id)
  end

  def flash_errors(scope)
    flash.now[:alert] = "#{alert_message(scope)} #{error_message}"
  end

  def alert_message(scope)
    I18n.t(:alert, scope: [:flash, :education_experience, scope])
  end

  def errors
    @education_experience.errors.full_messages.join('. ')
  end

  def error_message
    I18n.t(:errors, scope: :flash, errors:)
  end

  def new
    @education_experience = EducationExperience.new
  end

  def create
    @education_experience = EducationExperience.new(education_experience_params)

    if @education_experience.save
      redirect_to education_experiences_path, notice: I18n.t(:notice, scope: "flash.education_experience.create")
    else
      flash_errors('create')
      render :new
    end
  end

  private

  def education_experience_params
    params.require(:education_experience).permit(:institution, :course, :start_date, :end_date, :user_id)
  end

  def flash_errors(scope)
    flash.now[:alert] = "#{alert_message(scope)} #{error_message}"
  end

  def alert_message(scope)
    I18n.t(:alert, scope: [:flash, :education_experience, scope])
  end

  def errors
    @education_experience.errors.full_messages.join('. ')
  end

  def error_message
    I18n.t(:errors, scope: :flash, errors: errors)
  end
end
