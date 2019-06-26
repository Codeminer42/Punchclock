# frozen_string_literal: true

ActiveAdmin.register Company do
  permit_params :name, :avatar

  menu parent: Company.model_name.human, priority: 1

  filter :name, as: :select

  index do
    column :name
    column :id
    column :avatar
    column :created_at
    column :updated_at
    actions
  end
end
