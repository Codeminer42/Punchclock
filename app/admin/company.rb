ActiveAdmin.register Company do
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
