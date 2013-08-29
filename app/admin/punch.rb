ActiveAdmin.register Punch do
  total_hours = 0
  index do
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

  controller do
    def permitted_params
      params.permit(punch: [:from, :to, :project_id])
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

end