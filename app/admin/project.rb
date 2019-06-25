# frozen_string_literal: true

ActiveAdmin.register Project do
  config.sort_order = 'name_asc'

  permit_params :name, :company_id, :active, :client_id

  menu parent: Company.model_name.human

  scope :active, default: true
  scope :inactive

  filter :company, if: proc { current_admin_user.is_super? }
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

  index do
    selectable_column
    column :company if current_admin_user.is_super?
    column :name do |project|
      link_to project.name, admin_project_path(project)
    end
    column :active
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :active do |project|
        status_tag project.active.to_s
      end
      row :client
      row :company if current_admin_user.is_super?
      row :created_at
      row :updated_at
    end

    panel I18n.t('allocations') do
      table_for project.allocations do
        column :user
        column :start_at
        column :end_at
        column :access do |allocation|
          link_to I18n.t('view'), admin_allocation_path(allocation)
        end
      end
    end

  end

  form do |f|
    f.inputs 'Project Details' do
      f.input :name
      if current_admin_user.is_super?
        f.input :client
        f.input :company
      else
        f.input :client, collection: current_admin_user.company.clients.active.order(:name)
        f.input :company_id, as: :hidden, input_html: { value: current_admin_user.company_id }
      end
      f.input :active
    end
    f.actions
  end
end
