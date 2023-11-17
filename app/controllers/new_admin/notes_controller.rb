# frozen_string_literal: true

module NewAdmin
  class NotesController < NewAdminController
    layout 'new_admin'

    def index
      @notes = notes
    end

    private

    def notes
      NotesQuery.call filters
    end

    def filters
      params.permit(
        :title,
        :user_id,
        :author_id,
        :rate
      )
    end
  end
end
