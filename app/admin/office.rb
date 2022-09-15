# frozen_string_literal: true

ActiveAdmin.register Office do
  decorate_with OfficeDecorator
  config.sort_order = 'city_asc'

  permit_params :city, :head_id, :active

  menu parent: User.model_name.human(count: 2), priority: 3

  scope :all
  scope :active, default: true
  scope :inactive

  filter :city, as: :select, collection: -> { User.offices.order(:city) }
  filter :head, collection: -> { User.all.order(:name) }

  controller do
    def search_by_id
      @office = Office.find(params[:office][:id])
      redirect_to admin_office_path(@office)
    end
  end

  index download_links: [:xls] do
    column :city do |office|
      link_to office.city, admin_office_path(office)
    end
    column :head
    column :users_quantity do |office|
      office.users.active.size
    end
    column :score
    column :active
  end

  show title: proc{ |office| office.city } do
    attributes_table do
      row :city
      row :head
      row :score
      row :active
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
      f.input :head, collection: User.active.order(:name)
      f.input :active
    end
    f.actions
  end

  controller do
    def index
      super do |format|
        format.xls do
          spreadsheet = OfficesSpreadsheet.new find_collection(except: :pagination)
          send_data spreadsheet.to_string_io, filename: 'offices.xls'
        end
      end
    end
  end
end
