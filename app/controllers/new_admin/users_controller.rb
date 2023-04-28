# frozen_string_literal: true

module NewAdmin
  class UsersController < ApplicationController
    layout "new_admin"

    def show
      @user = User.find(params[:id]).decorate
      @user_allocations = Allocation.where(user_id: params[:id]).decorate
      @performance_evaluations = Evaluation.where(evaluated_id: params[:id])
    end
  end
end
