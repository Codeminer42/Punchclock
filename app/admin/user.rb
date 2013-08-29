ActiveAdmin.register User do
  index do
    column :id
    column :name
    column :email
    default_actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :password
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit user: [:name, :email, :password]
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
