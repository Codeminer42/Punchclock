ActiveAdmin.register User do
  filter :name
  filter :email
  filter :company, :if => proc { current_admin_user.is_super? }

  index do
    column :company
    column :name
    column :email
    default_actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      if current_admin_user.is_super?
        f.input :company
      else
        f.input :company, collection: {
          user.company.name => current_admin_user.company_id
        }
      end
      f.input :password
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit user: [:name, :email, :company_id, :password]
    end

    def new
      @user = User.new
      @user.company_id = current_admin_user.company.id unless current_admin_user.is_super?
      new!
    end

    def create
      create! do |success, failure|
        success.html do
          NotificationMailer.notify_user_registration(@user)
          redirect_to resource_path
        end
      end
    end
  end
end