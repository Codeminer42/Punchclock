ActiveAdmin.register Project do
  controller do
    def permitted_params
      params.permit project: [:name, :company_id]
    end
  end
end