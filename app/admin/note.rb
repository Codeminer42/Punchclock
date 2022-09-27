# frozen_string_literal: true

ActiveAdmin.register Note do
  permit_params :title, :rate, :comment, :user_id, :author_id

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
      f.input :author, collection: User.active.order(:name)
      f.input :user, collection: User.active.order(:name)
      f.input :comment
      f.input :rate
    end
    f.actions
  end
end
