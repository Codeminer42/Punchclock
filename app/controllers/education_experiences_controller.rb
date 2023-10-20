# frozen_string_literal: true

class EducationExperiencesController < ApplicationController
  before_action :authenticate_user!

  def index
    @undecorated_experiences = EducationExperience.for_user(current_user.id)
    @education_experiences = EducationExperiencePaginationDecorator.new(params, @undecorated_experiences)
  end
end
