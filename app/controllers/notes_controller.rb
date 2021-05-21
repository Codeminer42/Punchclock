class NotesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource except: :create

  def new
    user = User.find(params[:user_id])
    @note = user.notes.new
  end

  def create
    user = User.find(params[:user_id])
    @note = user.notes.new(note_params)
    @note.company_id = current_user.company_id
    @note.author = current_user

    if @note.save
      redirect_to evaluations_path, notice: I18n.t(:notice, scope: "flash.actions.create", resource_name: "Note")
    else
      flash_errors('create')
      render :new
    end
  end

  private
  def note_params
    params.require(:note).permit(:comment, :rate)
  end
end
