ActiveAdmin.register User do
  permit_params :name, :email, :company_id, :role, :reviewer_id, :hour_cost, :password, :active,
    :allow_overtime, :office_id

  config.sort_order = 'name_asc'

  scope :active, default: true
  scope :inactive
  scope :all

  filter :name
  filter :email
  filter :role, as: :select, collection: User.roles
  filter :office
  filter :company, if: proc { current_admin_user.is_super? }

  batch_action :destroy, false
  batch_action :disable, if: proc { params[:scope] != "inactive" } do |ids|
    batch_action_collection.find(ids).each(&:disable!)

    redirect_to collection_path, alert: "The users have been disabled."
  end

  batch_action :enable, if: proc { params[:scope] == "inactive" }  do |ids|
    batch_action_collection.find(ids).each(&:enable!)

    redirect_to collection_path, alert: "The users have been enabled."
  end

  index do
    selectable_column
    column :company if current_admin_user.is_super?
    column :name
    column :email
    column :office
    column :role
    column :hour_cost do |user|
      number_to_currency user.hour_cost
    end
    column :allow_overtime
    column :active
    actions
  end

  show do
    attributes_table do
      row :name
      row :email
      row :office
      row :role
      row :reviewer
      row :hour_cost do |user|
        number_to_currency user.hour_cost
      end
      row :allow_overtime do |user|
        status_tag user.allow_overtime.to_s
      end
      row :active do |user|
        status_tag user.active.to_s
      end
      row :last_sign_in_at
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :hour_cost, input_html: { value: '0.0' }
      f.input :office
      if current_admin_user.is_super?
        f.input :company
      else
        f.input :company_id, as: :hidden, input_html: { value: current_admin_user.company_id }
      end
      f.input :role, as: :select, collection: User.roles.keys
      f.input :reviewer
      f.input :allow_overtime
      f.input :password
      f.input :active
    end
    f.actions
  end

  controller do
    def scoped_collection
      super.includes :company, :reviewer
    end

    def create
      create! do |success, failure|
        success.html do
          NotificationMailer.notify_user_registration(@user).deliver
          redirect_to resource_path
        end
      end
    end

    def update
      params[:user].delete("password") if params[:user][:password].blank?
      super
    end
  end
end
