# frozen_string_literal: true

ActiveAdmin.register Note do
  permit_params :title, :rate, :comment, :user_id, :author_id, :company_id

  menu parent: Evaluation.model_name.human(count: 2), priority: 3

  filter :title
  filter :user
  filter :author
  filter :rate

  index do
    column :title
    column :author
    column :user
    column :rate
    column :created_at
    actions
  end

  form do |f|
    f.inputs Questionnaire.model_name.human do
      f.input :title
      f.input :author
      f.input :user
      if current_user.super_admin?
        f.input :company
      else
        f.input :company_id, as: :hidden, input_html: { value: current_user.company_id }
      end
      f.input :comment, input_html: {maxlength: 500}
      f.input :rate
    end
    f.actions
  end
end
