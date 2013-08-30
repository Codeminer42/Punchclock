ActiveAdmin.register AdminUser do  
  index do    
    if current_admin_user.is_super
      column :company
      column :email
      column :is_super
      default_actions
    else      
      column :email do |admin|
        next if admin.company_id != current_admin_user.company_id         
        mail_to admin.email
      end
      #actions
      column '' do |admin|
        next if admin.company_id != current_admin_user.company_id         
        
        links = ''.html_safe
        links += link_to "View", admin_admin_user_path(admin)
        links += ' '
        links += link_to "Edit", edit_admin_admin_user_path(admin) unless admin.is_super
        links += ' '
        links += link_to "Delete", admin_admin_user_path(admin), :method => :delete unless admin.is_super        
      end      
    end
  end

  filter :email

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :is_super, label: 'CAN MANAGE ALL COMPANIES?', :input_html => { disabled: !current_admin_user.is_super }
      if current_admin_user.is_super
        f.input :company
      else            
        f.input :company, :input_html => { value:Company.find(current_admin_user.company_id), disabled: true }, collection: [Company.find(current_admin_user.company_id)]
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
