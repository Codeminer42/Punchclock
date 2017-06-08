class CompanyController < ApplicationController
  before_action :authenticate_user!

  def edit
    @company = current_user.company
    respond_with @company
  end

  def update
    @company = current_user.company
    @company.update(company_params)
    respond_with @company, location: root_url
  end

  private

  def company_params
    params.require(:company).permit %w(name avatar remove_avatar)
  end
end
