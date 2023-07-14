# frozen_string_literal: true

ActiveAdmin.register EducationExperience do
  permit_params :user_id, :institution, :course, :start_date, :end_date

  filter :user
  filter :course
  filter :institution

  menu parent: [User.model_name.human(count: 2), I18n.t("active_admin.experience")], priority: 2

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
      f.input :institution, placeholder: 'Universidade de São Paulo'
      f.input :course, placeholder: 'Computer Science'
      f.input :start_date, as: :string, input_html: { class: %i[datepicker] }, placeholder: '2023-06-09'
      f.input :end_date, as: :string, input_html: { class: %i[datepicker] }, placeholder: '2023-06-09'
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
