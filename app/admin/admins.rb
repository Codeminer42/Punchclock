# frozen_string_literal: true

ActiveAdmin.register User, as: 'AdminUser' do
  decorate_with UserDecorator
  filter :email
  actions :index, :show

  menu priority: 2

  index download_links: [:xlsx] do
    column :name
    column :email
    actions only: :show
  end

  show do
    attributes_table do
      row :email
      row :roles, &:roles_text
      row :created_at
      row :updated_at
      row :last_sign_in_at
    end
  end

  controller do
    def scoped_collection
      User.active.admin
    end

    def index
      super do |format|
        format.xlsx do
          spreadsheet = AdminsSpreadsheet.new find_collection(except: :pagination)
          send_data spreadsheet.to_string_io, filename: 'admins.xlsx'
        end
      end
    end
  end
end
