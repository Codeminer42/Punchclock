class ProfessionalExperiencesController < ApplicationController
  before_action :authenticate_user!

  def index
    @professional_experiences = current_user.professional_experiences
  end
end
