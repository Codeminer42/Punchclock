# frozen_string_literal: true

ActiveAdmin.register Allocation do
  permit_params :user_id, :project_id, :start_at, :end_at, :company_id

  menu parent: I18n.t("activerecord.models.user.other"), priority: 4

  filter :user, collection: proc {
    current_admin_user.is_super? ? User.all.order(:name).group_by(&:company) : current_admin_user.company.users.order(:name)
  }
  filter :project, collection: proc {
    current_admin_user.is_super? ? Project.all.order(:name).group_by(&:company) : current_admin_user.company.projects.order(:name)
  }
  filter :start_at
  filter :end_at

  index do
    column :user
    column :project
    column :start_at
    column :end_at
    column :days_left, &:days_until_finish
    actions
  end

  show do
    attributes_table do
      row :user
      row :project
      row :start_at
      row :end_at
      row :days_left, &:days_until_finish
    end
  end

  form html: { autocomplete: 'off' } do |f|
    inputs 'Details' do
      if current_admin_user.is_super?
        input :user
        input :project
        input :company
      else
        input :user, as: :select, collection: current_admin_user.company.users.active.order(:name)
        input :project, collection: current_admin_user.company.projects.active.order(:name)
        input :company_id, as: :hidden, input_html: { value: current_admin_user.company_id }
      end
      input :start_at, as: :date_picker
      input :end_at, as: :date_picker
    end
    actions
  end
end
