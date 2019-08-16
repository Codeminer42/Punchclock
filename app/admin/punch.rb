# frozen_string_literal: true

ActiveAdmin.register Punch do
  decorate_with PunchDecorator

  permit_params :from, :to, :extra_hour, :user_id, :project_id, :company_id, :company, :comment

  menu priority: 100

  filter :project, collection: proc {
    current_user.super_admin? ? Project.order(active: :desc, name: :asc).group_by(&:company) : current_user.company.projects.order(:name)
  }
  filter :user, collection: proc { grouped_users_by_active_status(current_user.company) }
  filter :company, if: proc { current_user.super_admin? }
  filter :from, label: 'Intervalo', as: :date_range
  filter :extra_hour, label: 'Fez Hora Extra?'

  config.sort_order = 'from_desc'

  index do
    div class: 'panel' do
      h3 "Total: #{collection.total_hours}"
    end
    column :company, sortable: [:company, :name] if current_user.super_admin?
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
      row :company if current_user.super_admin?
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
      f.input :user, as: :select, collection: option_groups_from_collection_for_select(Company.all, :users, :name, :id, :name, f.object.user_id)
      f.input :project, as: :select, collection: option_groups_from_collection_for_select(Company.all, :projects, :name, :id, :name, f.object.project_id)
      f.input :company
      f.input :from, as: :datetime_picker
      f.input :to, as: :datetime_picker
      f.input :extra_hour
      f.input :comment
    end
    f.actions
  end

  controller do
    def scoped_collection
      super.includes :company, :user, :project
    end

    def index
      if params['q'] && params['q']['from_lteq']
        params['q']['from_lteq'] += ' 23:59:59.999999'
      end
      super do |format|
        format.xls do
          spreadsheet = PunchesSpreadsheet.new @punches
          send_data spreadsheet.generate_xls, filename: 'punches.xls'
        end
      end
    end
  end

  csv encoding: 'utf-8' do
    column :user
    column :project
    column :when
    column :from
    column :to
    column :delta
    column :extra_hour do |punch|
      t punch.extra_hour.to_s
    end
    column :comment
  end
end
