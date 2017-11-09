ActiveAdmin.register Project do
  config.sort_order = 'name_asc'

  scope :active, default: true
  scope :inactive

  index do
    column :company
    column :name
    column :created_at
    column :active
    actions :defaults => false do |f|
      if current_admin_user.is_super?
        [
        link_to('Visualizar', admin_project_path(f)), 
        ' ',  
        link_to('Editar',   edit_admin_project_path(f)),
        ' ',
        link_to('Deletar',  admin_project_path(f), data: { confirm: 'Are you sure?' }, :method => :delete)
        ].reduce(:+).html_safe
      else
        link_to('Visualizar',  admin_project_path(f))
      end
    end
  end

  
  form do |f|
    f.inputs 'Project Details' do
      f.input :name
      if current_admin_user.is_super?
        f.input :company
      else
        f.input :company, collection: {
          project.company.name => current_admin_user.company_id
        }
      end
      f.input :active
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit project: [:name, :company_id, :active]
    end

    def new
      @project = Project.new
      @project.company_id = current_company.id unless signed_in_as_super?
      new!
    end

    def signed_in_as_super?
      current_admin_user.is_super?
    end

    def current_company
      current_admin_user.company
    end
  end

  filter :company
  filter :name
  filter :created_at
  filter :updated_at
end
