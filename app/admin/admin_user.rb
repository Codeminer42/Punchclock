ActiveAdmin.register AdminUser do
  filter :email

  permit_params do
    params = %i[email password password_confirmation company_id]
    params.push :is_super if current_admin_user.is_super?
    params
  end

  index do
    column :company if current_admin_user.is_super?
    column :email
    column :is_super if current_admin_user.is_super?
    actions
  end

  action_item :reset_password, only: :show, if: proc { current_admin_user.is_super? } do
    link_to reset_password_admin_admin_user_path(resource), method: :post do
      t('admin_reset_password_button', scope: 'active_admin')
    end
  end

  member_action :reset_password, method: :post do
    resource.send_reset_password_instructions
    redirect_to resource_path, notice: t('admin_reset_password', scope: 'active_admin')
  end

  show do
    attributes_table do
      row :email
      row :company_id
      if current_admin_user.is_super?
        row :is_super do |admin|
          status_tag admin.is_super.to_s
        end
      end
      row :created_at
      row :updated_at
      row :last_sign_in_at
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
        f.input :company_id, as: :hidden, input_html: {value: current_admin_user.company_id}
      end
    end
    f.actions
  end

  controller do
    def scoped_collection
      all_admins = super.includes(:company)
      return all_admins if signed_in_as_super?
      all_admins.not_super
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

    def update_resource(object, attributes)
      update_method = attributes.first[:password].present? ? :update_attributes : :update_without_password
      object.send(update_method, *attributes)
    end

    def signed_in_as_super?
      current_admin_user.is_super?
    end
  end
end
