class TalksController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do
    redirect_to '/404'
  end

  before_action :authenticate_user!

  def index
    @talks = current_user.talks.page(params[:page])
  end

  def show
    @talk = current_user.talks.find(params[:id])
  end

  def edit
    @talk = current_user.talks.find(params[:id])
  end

  def update
    @talk = current_user.talks.find(params[:id])

    if @talk.update(talk_params)
      redirect_to talks_path, notice: I18n.t(:notice, scope: "flash.actions.update", resource_name: Talk.model_name.human)
    else
      flash_errors('update', Talk.model_name.human, error_message)
      render :edit
    end
  end

  private

  def talk_params
    params.require(:talk).permit(:event_name, :talk_title, :date)
  end

  def errors
    @talk.errors.full_messages.join('. ')
  end

  def error_message
    I18n.t(:errors, scope: :flash, errors:)
  end
end
