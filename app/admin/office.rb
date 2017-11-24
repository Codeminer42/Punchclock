ActiveAdmin.register Office do
  config.sort_order = 'city_asc'

  permit_params :company_id, :city

  filter :company, if: proc { current_admin_user.is_super? }
  filter :city

  index do
    column :city
    column :company
    column :users_quantity do |office|
      office.users.count
    end
    actions
  end

  show title: proc{ |office| office.city } do
    attributes_table do
      row :city
      row :users_quantity do |office|
        office.users.count
      end
      row :company
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs "Office details" do
      f.input :city
      if current_admin_user.is_super?
        f.input :company
      else
        f.input :company_id, as: :hidden, input_html: { value: current_admin_user.company_id }
      end
    end
    f.actions
  end
end
