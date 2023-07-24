# frozen_string_literal: true

class ContributionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user_contributions = scopped_contributions.approved.order(created_at: :desc)
  end

  def edit
    @contribution = scopped_contributions.find(params[:id])
  end

  def update
    @contribution = scopped_contributions.find(params[:id])

    @contribution.update(contribution_params)
    redirect_to contributions_path, notice: I18n.t(
      :notice, scope: "flash.actions.update", resource_name: Contribution.model_name.human
    )
  end

  private

  def scopped_contributions
    current_user.contributions
  end

  def contribution_params
    params.require(:contribution).permit(:description)
  end
end
