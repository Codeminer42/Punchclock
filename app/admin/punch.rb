# frozen_string_literal: true

ActiveAdmin.register Punch do
  decorate_with PunchDecorator
  permit_params :from, :to, :extra_hour, :user_id, :project_id, :comment

  menu priority: 100

  filter :project, collection: -> { Project.order(:name) }
  filter :user, collection: -> { grouped_users_by_active_status }
  filter :from, label: 'Intervalo', as: :date_range
  filter :extra_hour, label: 'Fez Hora Extra?'

  config.sort_order = 'from_desc'

  index download_links: [:xls] do
    column :user, sortable: [:user, :name]
    column :project, sortable: [:project, :name]
    column :when, sortable: :from
    column :from, sortable: false
    column :to, sortable: false
    column :delta, sortable: false
    column :extra_hour
    actions
  end

  show do
    attributes_table do
      row :user
      row :project
      row :when
      row :from
      row :to
      row :delta
      row :extra_hour
    end
  end

  form do |f|
    f.inputs do
      f.input :user, as: :select, collection: User.order(:name)
      f.input :project, as: :select, collection: Project.order(:name)
      f.input :from, as: :datetime_picker
      f.input :to, as: :datetime_picker
      f.input :extra_hour
      f.input :comment
    end
    f.actions
  end

  controller do
    def scoped_collection
      super.includes :user, :project
    end

    def index
      if params['q'] && params['q']['from_lteq']
        params['q']['from_lteq'] += ' 23:59:59.999999'
      end
      super do |format|
        format.xls do
          spreadsheet = PunchesSpreadsheet.new find_collection(except: :pagination)
          send_data spreadsheet.to_string_io, filename: 'punches.xls'
        end
      end
    end
  end
end
