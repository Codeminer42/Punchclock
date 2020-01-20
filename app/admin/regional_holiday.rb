# frozen_string_literal: true

ActiveAdmin.register RegionalHoliday do
  permit_params :name, :day, :month, :company_id, office_ids: []

  menu parent: Company.model_name.human

  filter :company, if: proc { current_user.super_admin? }
  filter :name
  filter :offices, multiple: true, collection: proc {
    current_user.super_admin? ? Office.all.order(:city).group_by(&:company) : current_user.company.offices.order(:city)
  }
  filter :day
  filter :month

  index download_links: [:xls] do
    column :company if current_user.super_admin?
    column :name
    column :day
    column :month
    column :offices do |holiday|
      offices_by_holiday(holiday)
    end
    actions
  end

  show do
    attributes_table do
      row :company if current_user.super_admin?
      row :id
      row :name
      row :day
      row :month
      row :offices do |holiday|
        offices_by_holiday(holiday)
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :day
      f.input :month
      f.input :company_id, as: :hidden, input_html: { value: current_user.company_id }
      f.input :offices, as: :check_boxes,
        collection: current_user.super_admin? ? Office.all.order(:city) : current_user.company.offices.order(:city)
    end
      f.actions
  end

  controller do
    def index
      super do |format|
        format.xls do
          spreadsheet = RegionalHolidaysSpreadsheet.new find_collection(except: :pagination)
          send_data spreadsheet.to_string_io, filename: 'regional_holidays.xls'
        end
      end
    end
  end

end
