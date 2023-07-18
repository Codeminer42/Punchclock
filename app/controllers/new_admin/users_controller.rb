# frozen_string_literal: true

module NewAdmin
  class UsersController < ApplicationController
    layout "new_admin"

    def show
      @user = User.find(params[:id]).decorate
      @user_allocations = Allocation.where(user_id: params[:id]).decorate
      @performance_evaluations = Evaluation.joins(:questionnaire).merge(Questionnaire.performance).where(evaluated_id: params[:id]).order(created_at: :desc).decorate
      @english_evaluations = Evaluation.joins(:questionnaire).merge(Questionnaire.english).where(evaluated_id: params[:id]).order(created_at: :desc).decorate
      @punches = if params[:from].nil? and params[:to].nil?
                   Punch.where(user_id: params[:id]).decorate
                 else
                   Punch.filter_by_date(params[:id], params[:from], params[:to]).decorate
                 end
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])

      @user.attributes = user_params

      if @user.save
        redirect_to new_admin_admin_user_path(@user)
      else
        flash_errors('update')
        redirect_to edit_new_admin_user_path(@user)
      end
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :github, :backend_level, :frontend_level, :level, :contract_type,
                                   :contract_company_country, :mentor_id, :city_id, :active, :allow_overtime, :office_id, :occupation, :started_at, :observation, :specialty, :otp_required_for_login, roles: [])
    end

    def flash_errors(scope)
      flash[:alert] = "#{alert_message(scope)} #{error_message}"
    end

    def errors
      @user.errors.full_messages.join('. ')
    end

    def alert_message(scope)
      I18n.t(:alert, scope: "flash.actions.#{scope}", resource_name: "Usuário")
    end

    def error_message
      I18n.t(:errors, scope: "flash", errors:)
    end
  end
end
