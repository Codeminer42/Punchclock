# frozen_string_literal: true

class EvaluationsController < ApplicationController
  load_and_authorize_resource except: :create

  before_action :authenticate_user!
  before_action :set_questionnaire, only: %i[new confirm]
  before_action :set_evaluation, only: :show
  before_action :set_evaluation_score_options, only: :new

  def index
    session[:evaluation_params] = nil
    @users = current_company.users.active.order(:name).decorate
  end

  def show
  end

  def new
    if session[:evaluation_params].present?
      @evaluation = Evaluation.new(session[:evaluation_params])
    else
      @evaluation = Evaluation.new(
        evaluator_id: current_user.id,
        evaluated_id: params[:evaluated_user_id],
        questionnaire_id: @questionnaire.id,
        company: current_company
      )
      @questionnaire.questions.each { |question| @evaluation.answers.build(question: question) }
    end
  end

  def create
    @evaluation = current_company.evaluations.new session[:evaluation_params]
    session[:evaluation_params] = nil

    if @evaluation.save
      redirect_to evaluations_path, notice: 'Evaluation successfully saved!'
    else
      redirect_to evaluations_path, notice: 'Something went wrong, try again!'
    end
  end

  def confirm
    @evaluation = Evaluation.new(evaluation_params)
    session[:evaluation_params] = evaluation_params

    if @evaluation.invalid?
      set_evaluation_score_options
      render :new
    end
  end

  def show_questionnaire_kinds
    questionnaires    = Questionnaire.active
    evaluated_user_id = params[:user_id]

    respond_to do |format|
      format.html do
        render partial: 'modal_select_form',
          locals: {
            questionnaires: questionnaires,
            evaluated_user_id: evaluated_user_id
          }
      end
    end
  end

  private

  def evaluation_params
    params.require(:evaluation).permit(:evaluator_id, :evaluated_id, :english_level,
                                       :questionnaire_id, :observation,  :score, :company_id,
                                       answers_attributes: %i[question_id response] )
  end

  def set_questionnaire
    @questionnaire = Questionnaire.find(params[:questionnaire_id])
  end

  def set_evaluation
    @evaluation = Evaluation.find(params[:id])
  end

  def set_evaluation_score_options
    @english_levels = Evaluation.english_levels.keys if @questionnaire.english?
  end
end
