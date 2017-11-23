ActiveAdmin.register Company do
  menu if: proc { current_admin_user.is_super? }

  index do
    column :name
    column :id
    column :avatar
    column :created_at
    column :updated_at
    actions
  end

  controller do
    def permitted_params
      params.permit company: [:name]
    end
  end
end
