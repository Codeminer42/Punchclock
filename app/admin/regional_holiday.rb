# frozen_string_literal: true

ActiveAdmin.register RegionalHoliday do
  permit_params :name, :day, :month, office_ids: [], city_ids: []

  filter :name
  filter :offices, multiple: true, collection: -> { Office.active.order(:city) }
  filter :cities, multiple: true, collection: -> { City.order(:name) }
  filter :day
  filter :month

  index download_links: [:xlsx] do
    column :name
    column :day
    column :month
    column :offices do |holiday|
      offices_by_holiday(holiday)
    end
    column :cities
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :day
      row :month
      row :offices do |holiday|
        offices_by_holiday(holiday)
      end
      row :cities
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :day
      f.input :month
      f.input :offices, as: :check_boxes, collection: Office.active.order(:city)
      f.input :cities, as: :select, multiple: true, collection: City.order(:name)
    end
      f.actions
  end

  controller do
    def index
      super do |format|
        format.xlsx do
          spreadsheet = RegionalHolidaysSpreadsheet.new find_collection(except: :pagination)
          send_data spreadsheet.to_string_io, filename: 'regional_holidays.xlsx'
        end
      end
    end
  end
end
