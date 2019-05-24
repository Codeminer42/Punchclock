# frozen_string_literal: true

ActiveAdmin.register Office do
  decorate_with OfficeDecorator
  config.sort_order = 'city_asc'

  permit_params :company_id, :city, :head_id

  menu parent: I18n.t("activerecord.models.user.other"), priority: 3

  filter :company, if: proc { current_admin_user.is_super? }
  filter :city, as: :select
  filter :head

  index do
    column :city do |office|
      link_to office.city, admin_office_path(office)
    end
    column :company if current_admin_user.is_super?
    column :head
    column :users_quantity do |office|
      office.users.active.size
    end
    column :score
  end

  show title: proc{ |office| office.city } do
    attributes_table do
      row :city
      row :company if current_admin_user.is_super?
      row :head
      row :score
      row :users_quantity do |office|
        office.users.active.size
      end
      row :users do
        table_for office.users do
          column :name do |user|
            link_to user.name, admin_allocation_path(user)
          end
          column :email
          column :occupation
          column :overall_score
        end
      end
    end
  end

  form do |f|
    f.inputs "Office details" do
      f.input :city
      if current_admin_user.is_super?
        f.input :head
        f.input :company
      else
        f.input :head, collection: current_admin_user.company.users
        f.input :company_id, as: :hidden, input_html: { value: current_admin_user.company_id }
      end
    end
    f.actions
  end
end
