# frozen_string_literal: true

module NewAdmin
  class UsersController < ApplicationController
    layout 'new_admin'
    before_action :load_user_data, only: :show

    before_action :authenticate_user!

    def show
      @punches = filter_punches_by_date(params[:id], params[:from], params[:to])
      AbilityAdmin.new(current_user).authorize! :read, Punch
    end

    private

    def load_user_data
      @user = find_user(params[:id])
      @user_allocations = find_user_allocations(params[:id])
      @performance_evaluations = find_performance_evaluations(params[:id])
      @english_evaluations = find_english_evaluations(params[:id])
    end

    def find_user(id)
      User.find(id).decorate
    end

    def find_user_allocations(id)
      Allocation.where(user_id: id).decorate
    end

    def find_performance_evaluations(id)
      Evaluation.joins(:questionnaire).merge(Questionnaire.performance)
                .where(evaluated_id: id).order(created_at: :desc).decorate
    end

    def find_english_evaluations(id)
      Evaluation.joins(:questionnaire).merge(Questionnaire.english)
                .where(evaluated_id: id).order(created_at: :desc).decorate
    end

    def filter_punches_by_date(id, from, to)
      if from.present? && to.present?
        Punch.filter_by_date(id, from, to).decorate
      else
        Punch.where(user_id: id).decorate
      end
    end
  end
end
