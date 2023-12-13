# frozen_string_literal: true

module NewAdmin
  class NotesController < NewAdminController
    load_and_authorize_resource

    def index
      @notes = paginate_record(notes)
    end

    def show
      @note = Note.find(params[:id])
    end

    def new
      @note = Note.new
    end

    def create
      @note = Note.new(note_params)

      if @note.save
        redirect_on_success new_admin_notes_path, message_scope: 'create'
      else
        render_on_failure :new
      end
    end

    def edit
      @note = Note.find(params[:id])
    end

    def update
      @note = Note.find(params[:id])

      if @note.update(note_params)
        redirect_on_success new_admin_show_note_path(id: @note.id), message_scope: 'update'
      else
        render_on_failure :edit
      end
    end

    def destroy
      @note = Note.find(params[:id])
      @note.destroy
      redirect_on_success new_admin_notes_path, message_scope: 'destroy'
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

    def note_params
      params.require(:note).permit(:title, :author_id, :user_id, :comment, :rate)
    end

    def redirect_on_success(url, message_scope:)
      flash[:notice] = I18n.t(:notice, scope: "flash.actions.#{message_scope}",
                                       resource_name: Note.model_name.human)
      redirect_to url
    end

    def render_on_failure(template)
      flash.now[:alert] = @note.errors.full_messages.to_sentence
      render template, status: :unprocessable_entity
    end
  end
end
