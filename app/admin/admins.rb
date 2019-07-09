# frozen_string_literal: true

ActiveAdmin.register User, as: 'AdminUser' do
  filter :email

  actions :index, :show

  menu priority: 2

  index do
    column :name
    column :email
    if current_user.super_admin?
      column :role 
      column :company
    end
    actions only: :show
  end

  show do
    attributes_table do
      row :email
      row :company if current_user.super_admin?
      row :role
      row :created_at
      row :updated_at
      row :last_sign_in_at
    end
  end

  controller do
    def scoped_collection
      current_user.super_admin? ? User.where(role: [:admin, :super_admin]) : User.admin.where(company_id: current_user.company_id)
    end
  end
end
