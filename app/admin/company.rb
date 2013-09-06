ActiveAdmin.register Company do
  controller do
    def permitted_params
      params.permit company: [:name]
    end
  end
end
