# frozen_string_literal: true

module NewAdmin
  class UsersController < ApplicationController
    layout "new_admin"

    def show
      @user = User.find(params[:id]).decorate
      @user_allocations = Allocation.where(user_id: params[:id]).decorate
      @performance_evaluations = Evaluation.joins(:questionnaire).merge(Questionnaire.performance).where(evaluated_id: params[:id]).order(created_at: :desc).decorate
      @english_evaluations = Evaluation.joins(:questionnaire).merge(Questionnaire.english).where(evaluated_id: params[:id]).order(created_at: :desc).decorate
    end
  end
end
