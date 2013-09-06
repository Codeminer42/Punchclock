ActiveAdmin.register AdminUser do
  filter :email

  index do
    column :company
    column :email
    column :is_super if can? :manage_all, Company if current_admin_user.is_super?
    default_actions
  end

  form do |f|
    f.inputs "Admin Details" do
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
    def permitted_params
      params.permit admin_user: [ :email, :password, :password_confirmation,
                                  :is_super, :company_id ]
    end

    def new
      @admin_user = AdminUser.new
      @admin_user.company_id = current_admin_user.company.id unless current_admin_user.is_super?
      new!
    end
  end
end
