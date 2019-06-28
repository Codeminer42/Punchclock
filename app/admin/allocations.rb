# frozen_string_literal: true

ActiveAdmin.register Allocation do
  permit_params :user_id, :project_id, :start_at, :end_at, :company_id

  menu parent: User.model_name.human(count: 2), priority: 4

  scope :ongoing, default: true
  scope :finished
  scope :all

  filter :user, collection: proc {
    current_admin_user.is_super? ? User.all.order(:name).group_by(&:company) : current_admin_user.company.users.order(:name)
  }
  filter :project, collection: proc {
    current_admin_user.is_super? ? Project.all.order(:name).group_by(&:company) : current_admin_user.company.projects.order(:name)
  }
  filter :start_at
  filter :end_at

  index do
    column :user
    column :project
    column :start_at
    column :end_at
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
      if current_admin_user.is_super?
        input :user
        input :project
        input :company
      else
        input :user, as: :select, collection: current_admin_user.company.users.active.order(:name)
        input :project, collection: current_admin_user.company.projects.active.order(:name)
        input :company_id, as: :hidden, input_html: { value: current_admin_user.company_id }
      end
        input :start_at, as: :date_picker, input_html: { value: f.object.start_at.try(:strftime, '%Y-%m-%d') }
        input :end_at, as: :date_picker, input_html: { value: f.object.end_at.try(:strftime, '%Y-%m-%d') }
    end
    actions
  end
end
