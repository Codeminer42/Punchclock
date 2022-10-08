class MyContributionsController < ApplicationController
  def index
    @user_contributions = Contribution.where user_id: current_user.id
  end
end
