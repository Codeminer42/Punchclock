# frozen_string_literal: true

class ContributionsController < ApplicationController
  def index
    @user_contributions = scopped_contributions.approved.order(pr_state: :desc)
  end

  def edit
    @contribution = scopped_contributions.find(params[:id])
  end

  def update
    @contribution = scopped_contributions.find(params[:id])

    if @contribution.update(normalize_blank_values)
      redirect_to contributions_path, notice: I18n.t(
        :notice, scope: "flash.actions.update", resource_name: Contribution.model_name.human
      )
    else
      flash_errors('update')
      render :edit
    end
  end

  private

  def scopped_contributions
    current_user.contributions
  end

  def contribution_params
    params.require(:contribution).permit(:description)
  end

  def normalize_blank_values
    contribution_params.to_hash.each_with_object({}) do |(key, value), accumulator|
      accumulator[key] = value.blank? ? nil : value

      accumulator
    end
  end
end
