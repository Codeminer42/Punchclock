ActiveAdmin.register EducationExperience do
  permit_params :user_id, :institution, :course, :start_date, :end_date

  filter :user
  filter :course
  filter :institution

  menu parent: User.model_name.human(count: 2), priority: 2

  index download_links: [:xlsx] do
    column :user
    column :institution
    column :course
    column :start_date
    column :end_date

    actions
  end

  form do |f|
    user_id = params[:user_id] || f.object.user_id
    f.inputs do 
      f.input :user, as: :select, collection: User.engineer.active.order(:name), selected: user_id 
      f.input :institution
      f.input :course
      f.input :start_date, as: :string, input_html: { class: %i(datepicker) }
      f.input :end_date, as: :string, input_html: { class: %i(datepicker) }
    end
    f.actions
  end

  show do
    attributes_table do
      row :user
      row :institution
      row :course
      row :start_date
      row :end_date
    end
  end
end
