# frozen_string_literal: true

class EducationExperiencesController < ApplicationController
  before_action :authenticate_user!

  def index
    @education_experiences = PunchesPaginationDecorator.new(params, EducationExperience.where(user_id: current_user.id))
  end
end
