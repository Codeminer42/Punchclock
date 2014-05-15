ActiveAdmin.register Punch do
  decorate_with PunchDecorator

  index do
    column :company, sortable: [:company, :name]
    column :user, sortable: [:user, :name]
    column :project, sortable: [:project, :name]
    column :when, sortable: :from
    column :from, sortable: false
    column :to, sortable: false
    column :delta, sortable: false
    default_actions
    div class: 'panel' do
      h3 "Total: #{collection.total_hours}"
    end
  end

  form do |f|
    f.inputs do
      if current_admin_user.is_super?
        f.input :user
        f.input :project
        f.input :company
      else
        f.input :user, collection: list_users
        f.input :project, collection: list_projects
        f.input :company, collection: {
          punch.company.name => current_admin_user.company_id
        }
      end
      f.input :from, as: :datetime_picker
      f.input :to, as: :datetime_picker
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit(punch: [:from, :to, :user_id, :project_id, :company_id])
    end

    def index
      if params['q'] && params['q']['from_lteq']
        params['q']['from_lteq'] += ' 23:59:59.999999'
      end
      index!
    end

    def new
      @punch = Punch.new
      @punch.company_id = current_company.id unless signed_in_as_super?
      new!
    end

    def signed_in_as_super?
      current_admin_user.is_super?
    end

    def current_company
      current_admin_user.company
    end

    def list_projects
      current_admin_user.company.projects.load.map { |p| [p.name, p.id] }
    end

    def list_users
      current_admin_user.company.users.load.map { |u| [u.name, u.id] }
    end
  end

  csv do
    column('User')    { |punch| punch.user.name }
    column('Project') { |punch| punch.project.name }
    column :when
    column :from
    column :to
    column :delta
  end

  filter :project
  filter :user
  filter :company
  filter :from, label: 'Interval', as: :date_range
end
