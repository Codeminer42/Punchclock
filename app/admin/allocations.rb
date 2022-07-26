# frozen_string_literal: true

ActiveAdmin.register Allocation do
  config.sort_order = ''
  permit_params :user_id, :project_id, :start_at, :end_at, :company_id

  config.batch_actions = false

  menu parent: User.model_name.human(count: 2), priority: 4

  scope :ongoing, default: true
  scope :finished
  scope :all do
    Allocation.all.joins(:user).merge(User.active)
  end
  scope :spreadsheet do |relation|
    AllocationsAndUnalocatedUsersQuery.new(relation, current_user.company).call
  end

  filter :user, collection: proc {
    current_user.super_admin? ? User.all.order(:name).group_by(&:company) : current_user.company.users.order(:name)
  }
  filter :project, collection: proc {
    current_user.super_admin? ? Project.all.order(:name).group_by(&:company) : current_user.company.projects.order(:name)
  }
  filter :start_at
  filter :end_at

  index download_links: [:xls] do
    # Temporary, we have a ticket to handle that column properly in
    # a near future
    column '#' do |allocation|
      if allocation.id.blank?
        'D'
      elsif allocation.end_at && allocation.end_at < Date.current
        'F'
      else
        'A'
      end
    end
    column :user
    column User.human_attribute_name('specialty') do |allocation|
      allocation.user.specialty.humanize
    end
    column :project
    column :start_at, sortable: false
    column :end_at, sortable: false
    column :days_left, &:days_until_finish
    actions
  end

  show do
    attributes_table do
      row :user
      row :project
      row :start_at
      row :end_at
      row :days_left, &:days_until_finish
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
      if current_user.super_admin?
        input :user
        input :project
        input :company
      else
        company_users_not_allocated = UsersByCompanyQuery
                                      .new(current_user.company)
                                      .not_allocated_including(f.object.user)
                                      .select(:id, :name)

        input :user, as: :select, collection: company_users_not_allocated
        input :project, collection: (current_user.company.projects.active.to_a | [@resource.project]).reject(&:blank?).sort_by(&:name)
        input :company_id, as: :hidden, input_html: { value: current_user.company_id }
      end

      input :start_at, as: :date_picker, input_html: { value: f.object.start_at }
      input :end_at, as: :date_picker, input_html: { value: f.object.end_at }
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
  end
end
