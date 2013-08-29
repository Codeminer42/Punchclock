ActiveAdmin.register User do
  index do
    column :id
    column :name
    column :email
    default_actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :password
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit user: [:name, :email, :password]
    end
  end
end
