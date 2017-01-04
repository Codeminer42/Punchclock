class EvaluationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @evaluation_kind = evaluation_kind

    if Evaluation.received?(@evaluation_kind)
      @evaluations = current_user.received_evaluations.includes(:reviewer).order(created_at: :desc)
    else
      @evaluations = current_user.written_evaluations.includes(:user).order(created_at: :desc)
    end
  end

  def show
    @evaluation_kind = evaluation_kind

    if Evaluation.received?(@evaluation_kind)
      @evaluation = current_user.received_evaluations.find(params[:id])
    else
      @evaluation = current_user.written_evaluations.find(params[:id])
    end
  end

  def new
    @users = find_evaluation_users
    @evaluation = Evaluation.new
  end

  def create
    @evaluation = current_user.written_evaluations.build(evaluation_params)
    if @evaluation.save
      flash[:notice] = I18n.t('evaluation.create.notice', scope: :flash)
      respond_with @evaluation, location: kind_evaluations_path(Evaluation::KINDS[:written])
    else
      @users = find_evaluation_users
      render :new
    end
  end

  def edit
    @users = find_evaluation_users
    @evaluation = current_user.written_evaluations.find(params[:id])
  end

  def update
    @evaluation = current_user.written_evaluations.find(params[:id])
    if @evaluation.update(evaluation_params)
      flash[:notice] = I18n.t('evaluation.update.notice', scope: :flash)
      respond_with @evaluation, location: kind_evaluations_path(Evaluation::KINDS[:written])
    else
      @users = find_evaluation_users
      render :edit
    end
  end

  private
  def evaluation_kind
    Evaluation::KINDS.fetch(params[:kind].to_sym, Evaluation::KINDS[:written])
  end

  def find_evaluation_users
    User.where(reviewer: current_user)
  end

  def evaluation_params
    params.require(:evaluation).permit(:user_id, :review)
  end
end
