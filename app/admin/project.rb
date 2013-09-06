ActiveAdmin.register Project do
  form do |f|
    f.inputs "Project Details" do
      f.input :name
      if current_admin_user.is_super?
        f.input :company
      else
        f.input :company, collection: {
          project.company.name => current_admin_user.company_id
        }
      end
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit project: [:name, :company_id]
    end

  	def new
  		@project = Project.new
  		@project.company_id = current_admin_user.company.id unless current_admin_user.is_super?
  		new!
  	end
  end
end