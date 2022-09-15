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
    params.require(:note).permit(:title, :comment, :rate)
  end

  def flash_errors(scope)
    flash.now[:alert] = "#{alert_message(scope)} #{error_message}"
  end

  def alert_message(scope)
    I18n.t(:alert, scope: "flash.actions.#{scope}", resource_name: "Note")
  end

  def errors
    @note.errors.full_messages.join('. ')
  end

  def error_message
    I18n.t(:errors, scope: "flash", errors: errors)
  end
end
