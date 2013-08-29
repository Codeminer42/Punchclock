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
      f.input :company
    end
    f.actions
  end
  controller do
    def permitted_params
      params.permit admin_user: [:email, :password, :password_confirmation,
                                 :is_super, :company_id]
    end
  end
end
