class MyContributionsController < ApplicationController
  def index
    @user_contributions = current_user.contributions.where(state: :approved).order(created_at: :desc)
  end
end
