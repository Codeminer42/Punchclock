# frozen_string_literal: true

ActiveAdmin.register User do
  decorate_with UserDecorator

  includes :mentor

  config.sort_order = 'name_asc'

  menu parent: User.model_name.human(count: 2), priority: 1

  permit_params :name, :email, :github, :backend_level, :frontend_level, :level, :contract_type, :contract_company_country, :mentor_id,
                :city_id, :active, :allow_overtime, :office_id, :occupation, :started_at,
                :observation, :specialty, :otp_required_for_login, skill_ids: [], roles: []

  scope :all
  scope :active, default: true, group: :active
  scope :inactive, group: :active
  scope :office_heads
  scope :admin
  scope :not_allocated, group: :allocation
  scope :allocated, group: :allocation

  filter :name
  filter :email

  filter :backend_level, as: :select, collection: User.backend_level.values.map { |level| [level.text, level.value] }
  filter :frontend_level, as: :select, collection: User.frontend_level.values.map { |level| [level.text, level.value] }

  filter :office, collection: -> { Office.active.order(:city) }
  filter :contract_type, as: :select, collection: User.contract_type.values.map { |contract_type| [contract_type.text.humanize, contract_type.value] }

  filter :by_skills, as: :check_boxes, collection: proc {
    Skill.order(:title).map do |skill|
      [skill.title, skill.id, checked: params.dig(:q, :by_skills_in)&.include?(skill.id.to_s)]
    end
  }

  batch_action :destroy, false
  batch_action :disable, if: proc { params[:scope] != "inactive" } do |ids|
    batch_action_collection.find(ids).each(&:disable!)

    redirect_to collection_path, notice: "The users have been disabled."
  end

  batch_action :enable, if: proc { params[:scope] == "inactive" }  do |ids|
    batch_action_collection.find(ids).each(&:enable!)

    redirect_to collection_path, notice: "The users have been enabled."
  end

  action_item :hour_report_current, only: :index, priority: 0 do
   link_to I18n.t('hour_report_curent_month'), hour_report_admin_users_path(format: :xlsx, month: :current)
  end

  action_item :hour_report_past, only: :index, priority: 0 do
   link_to I18n.t('hour_report_past_month'), hour_report_admin_users_path(format: :xlsx, month: :past)
  end

  action_item :user_registration, only: :show, priority: 0, if: -> { !user.confirmed? } do
    link_to I18n.t('resend_user_registration'), resend_user_registration_admin_user_path, method: :patch
  end

  index download_links: [:xlsx] do
    selectable_column
    column :name do |user|
      link_to user.name, admin_user_path(user)
    end
    column :office
    column :backend_level, &:backend_level_text
    column :frontend_level, &:frontend_level_text
    column :allow_overtime
    column :active
    column :"2fa" do |user|
      status_tag user.otp_required_for_login
    end
    actions
  end

  sidebar 'Filtro', only: :show, class: 'hide_custom_filter', partial: 'custom-filter-punches'

  show do
    tabs do
      tab User.model_name.human do
        attributes_table do
          row :name
          row :email
          row :"2fa" do
            status_tag user.otp_required_for_login
          end
          row :github
          row :office
          row :city, &:city_text
          row :managed_offices
          row :english_level
          row :overall_score
          row :performance_score
          row :occupation, &:occupation_text
          row :backend_level, &:backend_level_text
          row :frontend_level, &:frontend_level_text
          row :specialty, &:specialty_text
          row :level, &:level_text
          row :contract_type, &:contract_type_text
          row :contract_company_country, &:contract_company_country_text

          row :roles do |user|
            user.roles.map { |role| I18n.t(role, scope: 'enumerize.user.role') }
          end

          row :skills do |user|
            raw(skills_tags(user))
          end

          row :mentor
          row :mentees
          row :allow_overtime
          row :active
          row :started_at
          row :last_sign_in_at
          row :created_at
          row :updated_at
          row :observation
        end
      end

      tab Allocation.model_name.human(count: 2) do
        attributes_table do
          row :current_allocation
          row :allocations do
            table_for user.allocations.order(start_at: :desc) do
              column :project_name do |allocation|
                allocation.project.name
              end
              column :start_at
              column :end_at
              column :ongoing
              column '' do |allocation|
                link_to 'Access Allocation', admin_allocation_path(allocation)
              end
            end
          end
        end
      end

      tab I18n.t('perfomance_evaluations') do
        attributes_table do
          row :evaluation do
            table_for user.evaluations.by_kind(:performance).order(created_at: :desc) do
              column :created_at
              column :evaluator
              column :score
              column :questionnaire
              column '' do |evaluation|
                link_to 'Access Evaluation', admin_evaluation_path(evaluation)
              end
            end
          end
        end
      end

      tab I18n.t('english_evaluations') do
        attributes_table do
          row :english_level
          row :english_score
          row :evaluation do
            table_for user.evaluations.by_kind(:english).order(created_at: :desc) do
              column :created_at
              column :evaluator
              column :score
              column :questionnaire
              column '' do |evaluation|
                link_to 'Access Evaluation', admin_evaluation_path(evaluation)
              end
            end
          end
        end
      end

      tab :punches do
        from = params.dig(:punch, :from_gteq) || 60.days.ago
        to = params.dig(:punch, :from_lteq) || Time.zone.now

        table_for user.punches.where(from: from..to).order(from: :desc).decorate, i18n: Punch, id: 'table_admin_punches' do
          column :project
          column :when
          column :from
          column :to
          column :delta
          column :extra_hour
        end
        div link_to I18n.t('download_as_xls'),
                        admin_punches_path(q: { user_id_eq: user.id, from_greater_than: from, from_lteq: to }, format: :xls)
        div link_to I18n.t('all_punches'),
                        admin_punches_path(q: { user_id_eq: user.id, commit: :Filter })
      end

      tab I18n.t('experience') do
        panel I18n.t('professional_experience') do
        end

        panel I18n.t('educational_experience') do
          table_for user.education_experiences, i18n: EducationExperience do
            column :course
            column :institution
            column :start_date
            column :end_date
          end
          span do
            link_to I18n.t('active_admin.new_model', model: EducationExperience.model_name.human),
              new_admin_education_experience_path(user_id: user),
              class: "button"
          end

        end

        panel I18n.t('open_source_experience') do
          table_for user.contributions.valid_pull_requests.order(created_at: :desc).decorate, i18n: Contribution do
            column :name, i18n: Repository do |contribution|
              contribution.repository.name
            end
            column :description
            column :created_at
          end
        end

        panel I18n.t('talking_presenting_experience') do
          table_for user.talks.decorate, i18n: Talk do
            column :event_name
            column :talk_title
            column :date
          end

          span do
            link_to I18n.t('active_admin.new_model', model: Talk.model_name.human),
              new_admin_talk_path(user_id: user),
              class: "button"
          end
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :github
      f.input :started_at, as: :date_picker, input_html: { value: f.object.started_at }
      f.input :city, as: :select, collection: City.collection.map { |city| ["#{city.name} - #{city.state.code}", city.id] }
      f.input :office, collection: Office.active.order(:city)
      f.input :roles, as: :select, multiple: true, collection: User.roles.values.map { |role| [I18n.t(role, scope: 'enumerize.user.role'), role] }
      f.input :mentor, collection: User.active.order(:name)
      f.input :skills, as: :check_boxes, collection: Skill.order(:title)
      f.input :occupation, as: :radio
      f.input :backend_level, as: :select, collection: User.backend_level.options
      f.input :frontend_level, as: :select, collection: User.frontend_level.options
      f.input :specialty, as: :select, collection: User.specialty.values.map { |specialty| [specialty.text.humanize, specialty] }
      f.input :level, as: :select, collection: User.level.values.map { |level| [level.text.titleize,level] }
      f.input :contract_type, as: :select, collection: User.contract_type.values.map { |contract_type| [contract_type.text.humanize, contract_type] }
      f.input :contract_company_country, as: :select, collection: User.contract_company_country.values.map { |company_country| [company_country.text.humanize, company_country] }
      f.input :allow_overtime
      f.input :active
      f.input :otp_required_for_login, as: :boolean, :input_html => { checked: f.object.otp_required_for_login? }
      f.input :observation
    end
    f.actions
  end

  controller do
    def index
      super do |format|
        format.xlsx do
          spreadsheet = UsersSpreadsheet.new find_collection(except: :pagination)
          send_data spreadsheet.to_string_io, filename: 'users.xlsx'
        end
      end
    end

    def save_resource(object)
      object.password_required = false
      object.github = nil if object.github == ''

      super
    end

    def create
      create! do |success, _failure|
        success.html do
          NotificationMailer.notify_user_registration(@user).deliver_later
          redirect_to resource_path
        end
      end
    end
  end

  collection_action :hour_report do
    respond_to do |format|
      reference_date = if params[:month] == "current"
        Date.current
      else
        1.month.ago
      end

      date_range = reference_date.beginning_of_month..reference_date.end_of_month

      reports = find_collection(except: :pagination).flat_map do |user|
        HourReport.build_reports_for(user, date_range)
      end

      spreadsheet = HourReportSpreadsheet.new reports

      format.xlsx { send_data spreadsheet.to_string_io, filename: "users-hours-#{Date.current}.xlsx" }
    end
  end

  member_action :resend_user_registration, method: :patch do
    user = resource.user

    user.transaction do
      user.touch(:confirmed_at)
      token = user.send(:set_reset_password_token)
      NotificationMailer.resend_user_registration(resource, token).deliver_later

      redirect_to admin_user_path, notice: I18n.t('resend_user_registration_confirmed')
    end
  end
end
