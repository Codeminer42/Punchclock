# frozen_string_literal: true

module NewAdmin
  class EvaluationController < ApplicationController
    layout "new_admin"

    def index
      @evaluations = EvaluationQuery.new.call.decorate
    end

    def show
    end
  end
end
