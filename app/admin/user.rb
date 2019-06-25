# frozen_string_literal: true

ActiveAdmin.register User do
  decorate_with UserDecorator

  config.sort_order = 'name_asc'

  menu parent: I18n.t("activerecord.models.user.other"), priority: 1

  permit_params :name, :email, :github, :company_id, :role, :reviewer_id, :hour_cost,
                :password, :active, :allow_overtime, :office_id, :occupation,
                :admin, :observation, :specialty, skill_ids: []

  scope proc { I18n.t('all') }, :all
  scope proc { I18n.t('active') }, :active, default: true
  scope proc { I18n.t('inactive') }, :inactive
  scope :office_heads
  scope :admins
  scope proc { I18n.t('users_not_allocated') }, :not_allocated

  filter :name
  filter :email
  filter :role, as: :select, collection: User.roles.map {|key,value| [key.titleize, value]}
  filter :office, collection: proc {
    current_admin_user.is_super? ? Office.all.order(:city).group_by(&:company) : current_admin_user.company.offices.order(:city)
  }
  filter :company, if: proc { current_admin_user.is_super? }
  filter :specialty, as: :select, collection: User.specialties.map {|key,value| [key.humanize, value]}
  filter :by_skills, as: :check_boxes, collection: proc { Skill.order(:title) }


  batch_action :destroy, false
  batch_action :disable, if: proc { params[:scope] != "inactive" } do |ids|
    batch_action_collection.find(ids).each(&:disable!)

    redirect_to collection_path, alert: "The users have been disabled."
  end

  batch_action :enable, if: proc { params[:scope] == "inactive" }  do |ids|
    batch_action_collection.find(ids).each(&:enable!)

    redirect_to collection_path, alert: "The users have been enabled."
  end

  index do
    selectable_column
    column :name do |user|
      link_to user.name, admin_user_path(user)
    end
    column :office
    column :role
    column :specialty
    column :hour_cost do |user|
      number_to_currency user.hour_cost
    end
    column :allow_overtime
    column :active
    actions defaults: false do |user|
      link_to I18n.t('view'), admin_user_path(user)
    end
  end

  show do
    tabs do
      tab I18n.t('user') do
        attributes_table do
          row :name
          row :email
          row :github
          row :office
          row :managed_offices
          row :english_level
          row :overall_score
          row :performance_score
          row :occupation
          row :specialty
          row :role
          row :skills do
            user.skills.pluck(:title).to_sentence
          end
          row :reviewer
          row :hour_cost do |user|
            number_to_currency user.hour_cost
          end
          row :allow_overtime
          row :active
          row :last_sign_in_at
          row :created_at
          row :updated_at
          row :admin
          row :observation
        end
      end

      tab I18n.t('allocation') do
        attributes_table do
          row :current_allocation
          row :allocations do
            table_for user.allocations.order(start_at: :desc) do
              column :client do |allocation|
                allocation.project.client
              end
              column :project_name do |allocation|
                allocation.project.name
              end
              column :start_at
              column :end_at
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
        table_for user.punches.last_punches(60.days.ago).order(from: :desc).decorate, i18n: Punch do
          column :company
          column :project
          column :when
          column :from
          column :to
          column :delta
          column :extra_hour
        end
        div link_to I18n.t('download_as_csv'),
                        admin_punches_path(q: { user_id_eq: user.id, from_greater_than: Date.current - 60 }, format: :csv)
        div link_to I18n.t('all_punches'), 
                        admin_punches_path(q: { user_id_eq: user.id, commit: :Filter })
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :github
      f.input :hour_cost, input_html: { value: '0.0' }
      if current_admin_user.is_super?
        f.input :office
        f.input :company
        f.input :reviewer
        f.input :skills, as: :check_boxes
      else
        f.input :office, collection: current_admin_user.company.offices.order(:city)
        f.input :company_id, as: :hidden, input_html: { value: current_admin_user.company_id }
        f.input :reviewer, collection: current_admin_user.company.users.order(:name)
        f.input :skills, as: :check_boxes, collection: current_admin_user.company.skills.order(:title)
      end
      f.input :occupation, as: :radio
      f.input :specialty
      f.input :role, as: :select, collection: User.roles.keys.map {|role| [role.titleize, role]}
      f.input :password if f.object.new_record?
      f.input :allow_overtime
      f.input :active
      f.input :observation
    end
    f.actions
  end

  controller do
    def scoped_collection
      super.includes :company, :reviewer
    end

    def create
      create! do |success, failure|
        success.html do
          NotificationMailer.notify_user_registration(@user).deliver
          redirect_to resource_path
        end
      end
    end
  end
end
