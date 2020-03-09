class RepositoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :company_repositories
  
  def index
  end

  private

  def company_repositories
    @repositories = current_user.company.repositories.order(:link)
  end
end
