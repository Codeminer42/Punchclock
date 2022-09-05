# frozen_string_literal: true

ActiveAdmin.register User, as: 'AdminUser' do
  filter :email
  actions :index, :show

  menu priority: 2

  index download_links: [:xls] do
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
      if current_user.super_admin?
        User.active.by_roles_in(%i[admin super_admin])
      else
        User.active.admin.where(company_id: current_user.company_id)
      end
    end

    def index
      super do |format|
        format.xls do
          spreadsheet = AdminsSpreadsheet.new find_collection(except: :pagination)
          send_data spreadsheet.to_string_io, filename: 'admins.xls'
        end
      end
    end
  end
end
