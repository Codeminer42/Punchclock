# frozen_string_literal: true

module NewAdmin
  class UsersController < NewAdminController
    load_and_authorize_resource
    before_action :load_user_data, only: :show

    def index
      @users = paginate_record(users)
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)

      if @user.save
        redirect_on_success new_admin_users_path, message_scope: 'create'
      else
        render_on_failure :new
      end
    end

    def show
      @punches = filter_punches_by_date(params[:id], params[:from], params[:to])
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])

      @user.attributes = user_params

      if @user.save
        redirect_to new_admin_show_user_path(@user)
      else
        flash_errors('update')
        redirect_to edit_new_admin_user_path(@user)
      end
    end

    private

    def load_user_data
      @user = find_user(params[:id])
      @user_allocations = find_user_allocations(params[:id])
      @performance_evaluations = find_performance_evaluations(params[:id])
      @english_evaluations = find_english_evaluations(params[:id])
    end

    def find_user(id)
      User.find(id).decorate
    end

    def find_user_allocations(id)
      Allocation.where(user_id: id).decorate
    end

    def find_performance_evaluations(id)
      Evaluation.joins(:questionnaire).merge(Questionnaire.performance)
                .where(evaluated_id: id).order(created_at: :desc).decorate
    end

    def find_english_evaluations(id)
      Evaluation.joins(:questionnaire).merge(Questionnaire.english)
                .where(evaluated_id: id).order(created_at: :desc).decorate
    end

    def filters
      params.permit(
        :active,
        :backend_level,
        :contract_type,
        :email,
        :frontend_level,
        :is_admin,
        :is_allocated,
        :is_office_head,
        :name,
        :office_id,
        skill_ids: []
      )
    end

    def filter_punches_by_date(id, from, to)
      if from.present? && to.present?
        Punch.filter_by_date(id, from, to).decorate
      else
        Punch.where(user_id: id).decorate
      end
    end

    def users
      UsersQuery.call filters
    end

    def user_params
      params.require(:user).permit(:name, :email, :github, :backend_level, :frontend_level, :contract_type,
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

    def redirect_on_success(url, message_scope:)
      flash[:notice] = I18n.t(:notice, scope: "flash.actions.#{message_scope}",
                                       resource_name: User.model_name.human)
      redirect_to url
    end

    def render_on_failure(template)
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render template, status: :unprocessable_entity
    end
  end
end
