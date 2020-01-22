ActiveAdmin.register Repository do
  permit_params :company_id, :link

  filter :link
  filter :company, as: :select, if: proc { current_user.super_admin? }

  menu parent: Contribution.model_name.human(count: 2), priority: 2

  index do
    column :link
    column :company

    actions
  end

  form do |f|
    f.inputs do
      f.input :link
      if current_user.super_admin?
        f.input :company
      else
        f.input :company_id, as: :hidden, input_html: { value: current_user.company_id }
      end
    end
    f.actions
  end

  show do
    attributes_table do
      row :link
      row :company
      row :created_at
      row :updated_at
    end
  end
end
