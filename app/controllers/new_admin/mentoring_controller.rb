module NewAdmin
  class MentoringController < ApplicationController
    layout "new_admin"

    def index
      @mentorings = MentoringQuery.new.call
      @mentorings_group = @mentorings.group_by(&:office_city)
    end
  end
end
