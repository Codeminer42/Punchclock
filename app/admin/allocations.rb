# frozen_string_literal: true

ActiveAdmin.register Allocation do
  decorate_with AllocationDecorator

  config.sort_order = 'ongoing_desc'
  permit_params :user_id, :project_id, :hourly_rate, :hourly_rate_currency, :start_at, :end_at, :ongoing

  config.batch_actions = false

  menu parent: User.model_name.human(count: 2), priority: 4

  filter :ongoing
  filter :user, collection: User.active.order(:name)
  filter :project, collection: Project.active.order(:name)
  filter :start_at
  filter :end_at

  index download_links: [:xls] do
    column :user, sortable: 'users.name'
    column :project
    column :hourly_rate
    column :start_at, sortable: false
    column :end_at, sortable: false
    column :days_left, &:days_until_finish
    column :ongoing
    actions
  end

  show do
    attributes_table do
      row :user
      row :project
      row :hourly_rate
      row :start_at
      row :end_at
      row :days_left, &:days_until_finish
      row :ongoing
    end

    panel t('revenue_forecast') do
      table_for(RevenueForecastService.allocation_forecast(allocation.model)) do
        column :month do |data|
          "#{data[:month]}/#{data[:year]}"
        end
        column :working_days
        column :forecast do |data|
          humanized_money_with_symbol(data[:forecast])
        end
      end
    end

    panel t('allocated_user_punches', scope: 'active_admin') do
      paginated_collection(allocation.user_punches.page(params[:page]).per(10), download_links: false) do
        table_for(collection.decorate, sortable: false, i18n: Punch) do
          column :when
          column :from
          column :to
          column :delta
          column :extra_hour
          column :access do |punch|
            link_to I18n.t('view'), admin_punch_path(punch)
          end
        end
      end
      div link_to I18n.t('download_as_csv'),
                    admin_punches_path(q: { project_id_eq: allocation.project.id,
                                            user_id_eq: allocation.user.id,
                                            from_greater_than: 60.days.ago.to_date
                                          }, format: :csv)
    end
  end

  form html: { autocomplete: 'off' } do |f|
    inputs 'Details' do
      users = User.engineer.active.order(:name).select(:id, :name)

      input :user, as: :select, collection: users
      input :project, collection: (current_user.projects.active.to_a | [@resource.project]).reject(&:blank?).sort_by(&:name)
      input :hourly_rate
      input :hourly_rate_currency, as: :select, collection: Allocation::HOURLY_RATE_CURRENCIES
      input :start_at, as: :date_picker, input_html: { value: f.object.start_at }
      input :end_at, as: :date_picker, input_html: { value: f.object.end_at }
      input :ongoing
    end
    actions
  end

  controller do
    def index
      super do |format|
        format.xls do
          spreadsheet = AllocationsSpreadsheet.new find_collection(except: :pagination)
          send_data spreadsheet.to_string_io, filename: 'allocations.xls'
        end
      end
    end

    def scoped_collection
      end_of_association_chain.includes(:user)
    end
  end
end
