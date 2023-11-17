class TalksController < ApplicationController
  before_action :authenticate_user!

  def index
    @talks = current_user.talks.page(params[:page])
  end

  def show
    @talk = current_user.talks.find(params[:id])
  end

  def new
    @talk = Talk.new
  end

  def create
    @talk = current_user.talks.new(talk_params)

    if @talk.save
      redirect_to talks_path,
                  notice: I18n.t(:notice, scope: "flash.actions.create",
                                          resource_name: Talk.model_name.human)
    else
      flash_errors('create', Talk.model_name.human, error_message)
      render :new
    end
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

  def destroy
    @talk = current_user.talks.find(params[:id])
    @talk.destroy
    redirect_to talks_path,
                notice: I18n.t(:notice, scope: "flash.actions.destroy",
                                        resource_name: Talk.model_name.human)
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
