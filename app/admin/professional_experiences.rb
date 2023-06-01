ActiveAdmin.register ProfessionalExperience do
  permit_params :user_id, :company, :position, :description, :responsibilities, :start_date, :end_date

  filter :user
  filter :company
  filter :position

  menu parent: User.model_name.human(count: 2), priority: 2

  index do
    column :user
    column :company
    column :position
    column :start_date
    column :end_date

    actions
  end

  form do |f|
    f.inputs do 
      f.input :user, as: :select, collection: User.engineer.active.order(:name)
      f.input :company
      f.input :position
      f.input :description, as: :text
      f.input :responsibilities
      f.input :start_date, as: :string, input_html: { class: %i(datepicker) }
      f.input :end_date, as: :string, input_html: { class: %i(datepicker) }
    end
    f.actions
  end

  show do
    attributes_table do
      row :user
      row :company
      row :position
      row :description
      row :responsibilities
      row :start_date
      row :end_date
    end
  end
end

