ActiveAdmin.register Office do
  config.sort_order = 'city_asc'

  index do
    column :id
    column :company
    column :city
    column :users_quantity do |office|
      office.users.count
    end

    actions :defaults => false do |f|
      if current_admin_user.is_super?
        [
        link_to('Visualizar',  admin_office_path(f)), 
        ' ',  
        link_to('Editar',  edit_admin_office_path(f)),
        ' ',
        link_to('Deletar', admin_office_path(f), data: { confirm: 'Are you sure?' }, :method => :delete)
        ].reduce(:+).html_safe
      else
        link_to('Visualizar', admin_office_path(f))
      end
    end
  end

  show title: proc{ |office| office.city } do
    attributes_table do
      row :id
      row :company
      row :city
      row :users_quantity do |office|
        office.users.count
      end
      row :created_at
      row :updated_at
    end
  end

  controller do
    def permitted_params
      params.permit(office: [:company_id, :city])
    end
  end
end
