ActiveAdmin.register Company do
  index do
    column :name
    column :id
    column :avatar
    column :created_at
    column :updated_at
    actions :defaults => false do |f|
      if current_admin_user.is_super?
        [
        link_to('Visualizar', admin_company_path(f)), 
        ' ',  
        link_to('Editar',  edit_admin_company_path(f)),
        ' ',
        link_to('Deletar', admin_company_path(f), data: { confirm: 'Are you sure?' }, :method => :delete)
        ].reduce(:+).html_safe
      else
        link_to('Visualizar', admin_company_path(f))
      end
    end
  end

  controller do
    def permitted_params
      params.permit company: [:name]
    end
  end
end
