# frozen_string_literal: true

class EducationExperiencesController < ApplicationController
  before_action :authenticate_user!

  def index
    @education_experiences = EducationExperience.for_user(current_user.id).page(params[:page]).per(params[:per])
  end
end
