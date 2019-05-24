# frozen_string_literal: true

ActiveAdmin.register Client do
  permit_params :name, :company, :company_id, :active

  menu parent: I18n.t("activerecord.models.company.one"), priority: 3

  filter :company, if: proc { current_admin_user.is_super? }
  filter :name

  scope proc { I18n.t('active') }, :active, default: true
  scope proc { I18n.t('inactive') }, :inactive

  batch_action :destroy, false
  batch_action :disable, if: proc { params[:scope] != "inactive" } do |ids|
    batch_action_collection.find(ids).each(&:disable!)

    redirect_to collection_path, alert: "The client have been disabled."
  end

  batch_action :enable, if: proc { params[:scope] == "inactive" }  do |ids|
    batch_action_collection.find(ids).each(&:enable!)

    redirect_to collection_path, alert: "The client have been enabled."
  end

  index do
    selectable_column
    column :company if current_admin_user.is_super?
    column :name
    column :active
    actions
  end

  show do
    attributes_table do
      row :name
      row :active
      row :created_at
      row :updated_at
    end
    panel I18n.t('projects') do
      table_for client.projects do
        column :name do |project|
          link_to project.name, admin_project_path(project)
        end
        column :active
        column :access do |project|
          link_to :Access, admin_project_path(project)
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :active
      if current_admin_user.is_super?
        f.input :company
      else
        f.input :company_id, as: :hidden, input_html: { value: current_admin_user.company_id }
      end
    end
    f.actions
  end
end
