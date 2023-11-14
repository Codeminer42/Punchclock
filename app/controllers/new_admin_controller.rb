class NewAdminController < ApplicationController
  include NewAdmin::Pagination

  before_action :authenticate_user!

  private

  def current_ability
    @current_ability ||= AbilityAdmin.new(current_user)
  end
end
