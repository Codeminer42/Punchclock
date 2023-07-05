# frozen_string_literal: true

ActiveAdmin.register ProfessionalExperience do
  permit_params :user_id, :company, :position, :description, :responsibilities, :start_date, :end_date

  filter :user
  filter :company
  filter :position

  menu parent: [User.model_name.human(count: 2), I18n.t("active_admin.experience")]

  index do
    column :user
    column :company
    column :position
    column :start_date
    column :end_date

    actions
  end

  form do |f|
    user_id = params[:user_id] || f.object.user_id

    f.inputs do
      f.input :user, as: :select, collection: User.engineer.active.order(:name), selected: user_id
      f.input :company, placeholder: 'Codeminer42'
      f.input :position, placeholder: 'Software Engineer'
      f.input :description, as: :text, placeholder: 'As a backend developer, I worked on building a system...'
      f.input :responsibilities, placeholder: 'Ruby on Rails, React, Ruby'
      f.input :start_date, as: :string, input_html: { class: :datepicker }, placeholder: '2021-11-01'
      f.input :end_date, as: :string, input_html: { class: :datepicker }, placeholder: '2023-06-28'
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

