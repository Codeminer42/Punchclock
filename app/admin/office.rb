ActiveAdmin.register Office do
  config.sort_order = 'city_asc'

  permit_params :company_id, :city

  index do
    column :id
    column :company
    column :city
    column :users_quantity do |office|
      office.users.count
    end
    actions
  end

  show title: proc{ |office| office.city } do
    attributes_table do
      row :id
      row :company
      row :city
      row :users_quantity do |office|
        office.users.count
      end
      row :created_at
      row :updated_at
    end
  end
end
