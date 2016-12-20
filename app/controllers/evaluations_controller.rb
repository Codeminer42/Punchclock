class EvaluationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @evaluations = Evaluation.where(reviewer: current_user)
  end

  def show
    @evaluation = find_evaluation
  end

  def new
    @users = find_evaluation_users
    @evaluation = Evaluation.new
  end

  def create
    @evaluation = current_user.evaluations.build(evaluation_params)
    if @evaluation.save
      flash[:notice] = I18n.t('evaluation.create.notice', scope: :flash)
      respond_with @evaluation, location: evaluations_path
    else
      @users = find_evaluation_users
      render :new
    end
  end

  def edit
    @users = find_evaluation_users
    @evaluation = find_evaluation
  end

  def update
    @evaluation = find_evaluation
    if @evaluation.update(evaluation_params)
      flash[:notice] = I18n.t('evaluation.update.notice', scope: :flash)
      respond_with @evaluation, location: evaluations_path
    else
      @users = find_evaluation_users
      render :edit
    end
  end

  private
  def find_evaluation
    current_user.evaluations.find(params[:id])
  end

  def find_evaluation_users
    User.where(reviewer: current_user)
  end

  def evaluation_params
    params.require(:evaluation).permit(:user_id, :review)
  end
end
