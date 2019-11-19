# frozen_string_literal: true

ActiveAdmin.register Company do
  permit_params :name, :avatar

  menu parent: Company.model_name.human, priority: 1

  filter :name, as: :select

  index download_links: [:xls] do
    column :name
    column :id
    column :avatar
    column :created_at
    column :updated_at
    actions
  end

  controller do
    def index
      super do |format|
        format.xls do
          spreadsheet = CompaniesSpreadsheet.new @companies
          send_data spreadsheet.to_string_io, filename: 'companies.xls'
        end
      end
    end
  end
end
