ActiveAdmin.register Client do
  permit_params :name, :company, :company_id, :active

  filter :company, if: proc { current_admin_user.is_super? }
  filter :name

  scope :active, default: true
  scope :inactive

  batch_action :destroy, false
  batch_action :disable, if: proc { params[:scope] != "inactive" } do |ids|
    batch_action_collection.find(ids).each(&:disable!)

    redirect_to collection_path, alert: "The client have been disabled."
  end

  batch_action :enable, if: proc { params[:scope] == "inactive" }  do |ids|
    batch_action_collection.find(ids).each(&:enable!)

    redirect_to collection_path, alert: "The client have been enabled."
  end

  index do
    selectable_column
    column :company if current_admin_user.is_super?
    column :name
    column :active
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :active
      if current_admin_user.is_super?
        f.input :company
      else
        f.input :company_id, as: :hidden, input_html: { value: current_admin_user.company_id }
      end
    end
    f.actions
  end
end
