# frozen_string_literal: true

module NewAdmin
  class EvaluationsController < ApplicationController
    layout 'new_admin'

    load_and_authorize_resource

    before_action :authenticate_user!

    def index
      @evaluations = EvaluationQuery.new(**search_params).call.decorate
    end

    def show
      @evaluation = Evaluation.find(params[:id])
    end

    private

    def search_params
      params.permit(
        :evaluator_id,
        :evaluated_id,
        :questionnaire_type,
        :created_at_start,
        :created_at_end,
        :evaluation_date_start,
        :evaluation_date_end
      ).to_h
    end
  end
end
