ActiveAdmin.register Project do
  config.sort_order = 'name_asc'

  permit_params :name, :company_id, :active

  scope :active, default: true
  scope :inactive

  filter :company, if: proc { current_admin_user.is_super? }
  filter :name
  filter :created_at
  filter :updated_at

  index do
    column :company if current_admin_user.is_super?
    column :name
    column :active
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :active do |project|
        status_tag project.active.to_s
      end
      row :created_at
      row :updated_at
      row :company if current_admin_user.is_super?
    end
  end

  form do |f|
    f.inputs 'Project Details' do
      f.input :name
      if current_admin_user.is_super?
        f.input :company
      else
        f.input :company_id, as: :hidden, input_html: { value: current_admin_user.company_id }
      end
      f.input :active
    end
    f.actions
  end
end
