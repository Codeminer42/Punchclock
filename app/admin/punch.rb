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
    column :extra_hour, sortable: false
    actions :defaults => false do |f|
      if current_admin_user.is_super?
        [
        link_to('Visualizar', admin_punch_path(f)), 
        ' ',  
        link_to('Editar',   edit_admin_punch_path(f)),
        ' ',
        link_to('Deletar', admin_punch_path(f), data: { confirm: 'Are you sure?' }, :method => :delete)
        ].reduce(:+).html_safe
      else
        link_to('Visualizar',  admin_punch_path(f))
      end
    end
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
      f.input :extra_hour, as: :datetime_picker
    end
    f.actions
  end

  controller do
    def scoped_collection
      super.includes :company, :user, :project
    end

    def permitted_params
      params.permit(punch: [:from, :to, :extra_hour, :user_id, :project_id, :company_id])
    end

    def index
      if params['q'] && params['q']['from_lteq']
        params['q']['from_lteq'] += ' 23:59:59.999999'
      end
      super
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
    column :extra_hour
  end

  filter :project, collection: proc { Project.order('name') }
  filter :user, collection: proc { grouped_users_by_active_status }
  filter :company
  filter :from, label: 'Interval', as: :date_range
end
