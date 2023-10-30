# frozen_string_literal: true

module NewAdmin
  class MentoringsController < NewAdminController
    before_action :authorize_ability!, only: :index

    def index
      @mentorings = paginate_record(all_mentorings, decorate: false)
      @mentorings_group = mentorings_by_office
    end

    private

    def mentorings_by_office
      all_mentorings.group_by(&:office_city)
    end

    def all_mentorings
      @all_mentorings ||= MentoringQuery.new.call
    end

    def authorize_ability!
      AbilityAdmin.new(current_user).authorize! :read, :mentoring
    end
  end
end
