# frozen_string_literal: true

class EducationExperiencesController < ApplicationController
  before_action :authenticate_user!

  def index
<<<<<<< HEAD
    @undecorated_experiences = EducationExperience.for_user(current_user.id)
    @education_experiences = EducationExperiencePaginationDecorator.new(params, @undecorated_experiences)
=======
    @education_experiences = PunchesPaginationDecorator.new(params, EducationExperience.where(user_id: current_user.id))
>>>>>>> 1aaaab0b (create education experiences index action)
  end
end
