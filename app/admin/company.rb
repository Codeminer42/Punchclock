ActiveAdmin.register Company do
  menu :if => proc{ can? :manage_all, Company }

  controller do
    def permitted_params
      params.permit company: [:name]
    end
  end
end
