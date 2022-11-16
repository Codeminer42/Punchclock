class ContributionsController < ApplicationController
  def index
    @user_contributions = current_user.contributions.approved.order(pr_state: :desc)
  end
end
