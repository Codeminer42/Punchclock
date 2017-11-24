ActiveAdmin.register Company do
  menu if: proc { current_admin_user.is_super? }

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
