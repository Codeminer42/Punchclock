ActiveAdmin.register AdminUser do
  index do
    column :company
    column :email
    column :is_super
    default_actions
  end

  filter :email

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :is_super, label: 'CAN MANAGE ALL COMPANIES?'
      if current_admin_user.is_super
        f.input :company
      else            
        f.input :company, value:Company.find(current_admin_user.company_id), collection: [Company.find(current_admin_user.company_id)]
      end
    end
    f.actions
  end
  controller do
    def scoped_collection
      if current_admin_user.is_super?
        AdminUser.all
      else
        AdminUser.where(company_id: current_admin_user.company_id)
      end
    end

    def permitted_params
      params.permit admin_user: [:email, :password, :password_confirmation,
                                 :is_super, :company_id]
    end
  end
end
