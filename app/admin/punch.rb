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
        f.input :user, collection: current_admin_user.company.users.load.map { |u| [u.name, u.id] }
        f.input :project, collection: current_admin_user.company.projects.load.map { |p| [p.name, p.id] }
        f.input :company, collection: {
          punch.company.name => current_admin_user.company_id
        }
      end
      f.input :from, :as => :datetime_picker
      f.input :to, :as => :datetime_picker
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit(punch: [:from, :to, :user_id, :project_id, :company_id])
    end

    def index
      params['q']['from_lteq'] += ' 23:59:59.999999' if params['q'] and params['q']['from_lteq']
      index!
    end

    def new
      @punch = Punch.new
      @punch.company_id = current_admin_user.company.id unless current_admin_user.is_super?
      new!
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
