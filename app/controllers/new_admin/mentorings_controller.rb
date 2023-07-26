# frozen_string_literal: true

module NewAdmin
  class MentoringsController < ApplicationController
    layout 'new_admin'

    before_action :authenticate_user!

    def index
      AbilityAdmin.new(current_user).authorize! :read, :mentoring

      @mentorings = MentoringQuery.new.call
      @mentorings_group = @mentorings.group_by(&:office_city)
    end
  end
end
