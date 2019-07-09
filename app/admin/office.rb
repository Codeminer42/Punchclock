# frozen_string_literal: true

ActiveAdmin.register Office do
  decorate_with OfficeDecorator
  config.sort_order = 'city_asc'

  permit_params :company_id, :city, :head_id

  menu parent: User.model_name.human(count: 2), priority: 3

  filter :company, if: proc { current_user.super_admin? }
  filter :city, as: :select, collection: proc {
    current_user.super_admin? ? Office.all.group_by(&:company) : current_user.company.offices.order(:city)
  }
  filter :head, collection: proc {
    current_user.super_admin? ? User.all.order(:name) : current_user.company.users.order(:name)
  }

  controller do
    def search_by_id
      @office = Office.find(params[:office][:id])
      redirect_to admin_office_path(@office)
    end
  end

  index do
    column :city do |office|
      link_to office.city, admin_office_path(office)
    end
    column :company if current_user.super_admin?
    column :head
    column :users_quantity do |office|
      office.users.active.size
    end
    column :score
  end

  show title: proc{ |office| office.city } do
    attributes_table do
      row :city
      row :company if current_user.super_admin?
      row :head
      row :score
      row :users_quantity do |office|
        office.users.active.size
      end
      row :users do
        table_for office.users.active do
          column :name do |user|
            link_to user.name, admin_user_path(user)
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
      if current_user.super_admin?
        f.input :head
        f.input :company
      else
        f.input :head, collection: current_user.company.users.active.order(:name)
        f.input :company_id, as: :hidden, input_html: { value: current_user.company_id }
      end
    end
    f.actions
  end
end
