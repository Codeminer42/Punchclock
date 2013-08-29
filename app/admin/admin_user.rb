ActiveAdmin.register AdminUser do
  index do
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end

  filter :email

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :is_super, label: 'CAN MANAGE ALL COMPANIES?'
    end
    f.actions
  end
  controller do
    def permitted_params
      params.permit admin_user: [:email, :password, :password_confirmation,
                                 :is_super]
    end
  end
end
