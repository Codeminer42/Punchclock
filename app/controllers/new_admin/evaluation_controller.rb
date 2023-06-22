module NewAdmin
  class EvaluationController < ApplicationController
    layout "new_admin"

    def index
      @mentorings = MentoringQuery.new.call
      @mentorings_group = @mentorings.group_by(&:office_city)
    end
  end
end
