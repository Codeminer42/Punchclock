ActiveAdmin.register Punch do
  total_hours = 0
  index do
    column :company
    column :user
    column :project, sortable: [:project, :name]
    column 'When', sortable: :from do |punch|
      l punch.from, format: '%d/%m/%Y'
    end
    column 'From' do |punch|
      l punch.from, format: '%H:%M'
    end
    column 'To' do |punch|
      l punch.to, format: '%H:%M'
    end
    column 'Delta' do |punch|
      total_hours = total_hours + punch.delta
      "#{time_format(punch.delta)}"
    end
    default_actions
    div class: 'panel' do
      h3 "Total: #{time_format(total_hours)}"
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
    column('When')    { |punch| l punch.from, format: '%d/%m/%Y' }
    column('From')    { |punch| l punch.from, format: '%H:%M' }
    column('To')      { |punch| l punch.to, format: '%H:%M' }
    column('Delta')   { |punch| "#{time_format(punch.delta)}" }
  end

  filter :project
  filter :user
  filter :company
  filter :from, label: 'Interval', as: :date_range
end
