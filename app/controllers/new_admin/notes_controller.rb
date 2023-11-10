# frozen_string_literal: true

module NewAdmin
  class NotesController < ApplicationController
    layout 'new_admin'

    def index
      @notes = Note.all
    end
  end
end
