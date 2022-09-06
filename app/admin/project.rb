# frozen_string_literal: true

ActiveAdmin.register Project do
  config.sort_order = 'name_asc'

  permit_params :name, :company_id, :active

  before_action :create_form, only: :show

  menu parent: Company.model_name.human

  scope :active, default: true
  scope :inactive

  filter :company, if: proc { current_user.super_admin? }
  filter :name
  filter :created_at
  filter :updated_at

  batch_action :destroy, false
  batch_action :disable, if: proc { params[:scope] != "inactive" } do |ids|
    batch_action_collection.find(ids).each(&:disable!)

    redirect_to collection_path, alert: "The projects have been disabled."
  end

  batch_action :enable, if: proc { params[:scope] == "inactive" }  do |ids|
    batch_action_collection.find(ids).each(&:enable!)

    redirect_to collection_path, alert: "The projects have been enabled."
  end

  collection_action :allocate_users, method: :post do
    @allocate_users_form = AllocateUsersForm.new(permited_allocation_params)
    if @allocate_users_form.save
      redirect_to admin_allocations_path, notice: I18n.t('allocate_users_form.success')
    else
      redirect_to admin_project_path(@allocate_users_form.project_id), alert: I18n.t('allocate_users_form.error')
    end
  end

  index download_links: [:xls] do
    selectable_column
    column :company if current_user.super_admin?
    column :name do |project|
      link_to project.name, admin_project_path(project)
    end
    column :active
    column :created_at
    actions
  end

  show do
    tabs do
      tab I18n.t('main') do
        attributes_table do
          row :name
          row :active
          row :company if current_user.super_admin?
          row :created_at
          row :updated_at
        end

        panel Allocation.model_name.human(count: 2) do
          table_for project.allocations.ongoing do
            column :user
            column :start_at
            column :end_at
            column :access do |allocation|
              link_to I18n.t('view'), admin_allocation_path(allocation)
            end
          end
        end
      end

      tab I18n.t('allocate_users') do
        render 'allocate_users'
      end
    end
  end

  form do |f|
    f.inputs I18n.t('project_details') do
      f.input :name
      if current_user.super_admin?
        f.input :company
      else
        f.input :company_id, as: :hidden, input_html: { value: current_user.company_id }
      end
      f.input :active
    end
    f.actions
  end

  controller do
    def create_form
      @allocate_users_form = AllocateUsersForm.new
    end

    def permited_allocation_params
      params.require(:allocate_users_form).permit(:company_id, :project_id, :start_at, :end_at, :not_allocated_users)
    end

    def index
      super do |format|
        format.xls do
          spreadsheet = ProjectsSpreadsheet.new find_collection(except: :pagination)
          send_data spreadsheet.to_string_io, filename: 'projects.xls'
        end
      end
    end
  end
end
