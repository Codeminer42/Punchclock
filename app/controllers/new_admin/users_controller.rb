# frozen_string_literal: true

module NewAdmin
  class UsersController < ApplicationController
    layout "new_admin"

    def show
      @user = User.find(params[:id]).decorate
      @user_allocations = Allocation.where(user_id: params[:id]).decorate
      @performance_evaluations = Evaluation.joins(:questionnaire).merge(Questionnaire.performance).where(evaluated_id: params[:id]).order(created_at: :desc).decorate
      @english_evaluations = Evaluation.joins(:questionnaire).merge(Questionnaire.english).where(evaluated_id: params[:id]).order(created_at: :desc).decorate
      if params[:from].nil? and params[:to].nil?
        @punches = Punch.where(user_id: params[:id]).decorate
      else
        @punches = Punch.all.filter_by_date(params[:id], params[:from], params[:to]).decorate
      end 
    end
  end
end
