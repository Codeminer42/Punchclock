# frozen_string_literal: true

module NewAdmin
  class NotesController < NewAdminController
    load_and_authorize_resource

    def index
      @notes = paginate_record(notes)
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
