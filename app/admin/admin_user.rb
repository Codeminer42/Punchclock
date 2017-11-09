ActiveAdmin.register AdminUser do
  index do
    column :company
    column :email
    column :is_super if current_admin_user.is_super?
    actions :defaults => false do |f|
      if current_admin_user.is_super?
        [
        link_to('Visualizar', admin_admin_user_path(f)), 
        ' ',  
        link_to('Editar',   edit_admin_admin_user_path(f)),
        ' ',
        link_to('Deletar', admin_admin_user_path(f), data: { confirm: 'Are you sure?' }, :method => :delete)
        ].reduce(:+).html_safe
      else
        link_to('Visualizar', admin_admin_user_path(f))
      end
    end
  end

  form do |f|
    f.inputs 'Admin Details' do
      f.input :email
      f.input :password
      f.input :password_confirmation
      if current_admin_user.is_super?
        f.input :is_super, label: 'CAN MANAGE ALL COMPANIES?'
        f.input :company
      else
        f.input :company, collection: {
          current_admin_user.company.name => current_admin_user.company_id
        }
      end
    end
    f.actions
  end

  controller do
    
    def scoped_collection
      super.includes :company
    end

    def permitted_params
      params.permit admin_user: [:email, :password, :password_confirmation,
                                 :is_super, :company_id]
    end

    def new
      @admin_user = AdminUser.new
      @admin_user.company_id = current_company.id unless signed_in_as_super?
      new!
    end

    def create
      create! do |success, failure|
        success.html do
          if signed_in_as_super?
            NotificationMailer.notify_admin_registration(@admin_user).deliver
          end
          redirect_to resource_path
        end
      end
    end

    def signed_in_as_super?
      current_admin_user.is_super?
    end

    def current_company
      current_admin_user.company
    end
  end

  filter :email

end
