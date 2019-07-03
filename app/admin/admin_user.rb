# frozen_string_literal: true

ActiveAdmin.register User, as: 'AdminUser' do
  filter :email

  actions :index, :show

  menu priority: 2

  index do
    column :company
    column :email
    column :role do |user|
      user.role.titleize
    end
    actions only: :show
  end

  show do
    attributes_table do
      row :email
      row :company
      row :role do |user|
        user.role.titleize
      end
      row :created_at
      row :updated_at
      row :last_sign_in_at
    end
  end

  controller do
    def scoped_collection
      signed_in_as_super? ? User.admin : User.where(role: :admin, company_id: current_admin_user.company_id)
    end

    def signed_in_as_super?
      current_admin_user.super_admin?
    end
  end
end
