ActiveAdmin.register Punch do
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
      "#{punch.delta} hs"
    end
    default_actions
  end
end
