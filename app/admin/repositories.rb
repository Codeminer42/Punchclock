ActiveAdmin.register Repository do
  permit_params :company_id, :link, :language

  filter :link
  filter :language
  filter :company, as: :select, if: proc { current_user.super_admin? }

  menu parent: Contribution.model_name.human(count: 2), priority: 2

  index download_links: [:xls] do
    column :link
    column :language
    column :company

    actions
  end

  form do |f|
    f.inputs do
      f.input :link
      f.input :language
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
      row :language
      row :company
      row :created_at
      row :updated_at
    end
  end

  controller do
    def index
      super do |format|
        format.xls do
          spreadsheet = RepositoriesSpreadsheet.new find_collection(except: :pagination)
          send_data spreadsheet.to_string_io, filename: "#{Repository.model_name.human(count: 2)}.xls"
        end
      end
    end
  end
end
