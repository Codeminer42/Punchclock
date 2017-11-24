ActiveAdmin.register Company do
  permit_params :name, :avatar

  index do
    column :name
    column :id
    column :avatar
    column :created_at
    column :updated_at
    actions
  end
end
