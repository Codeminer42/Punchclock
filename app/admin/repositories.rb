ActiveAdmin.register Repository do
  permit_params :link, :language

  filter :link
  filter :language

  menu parent: Contribution.model_name.human(count: 2), priority: 2

  index download_links: [:xlsx] do
    column :link
    column :language

    actions
  end

  form do |f|
    f.inputs do
      f.input :link
      f.input :language
    end
    f.actions
  end

  show do
    attributes_table do
      row :link
      row :language
      row :created_at
      row :updated_at
    end
  end

  controller do
    def index
      super do |format|
        format.xlsx do
          spreadsheet = RepositoriesSpreadsheet.new find_collection(except: :pagination)
          send_data spreadsheet.to_string_io, filename: "#{Repository.model_name.human(count: 2)}.xlsx"
        end
      end
    end
  end
end
