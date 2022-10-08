class MyContributionsController < ApplicationController
  def index
    @user_contributions = Contribution.where(user_id: current_user.id).order(created_at: :desc)
  end
end
