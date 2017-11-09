ActiveAdmin.register Evaluation do
  actions :index, :show

  index do
    column :user
    column :reviewer
    column :created_at
    column :updated_at
    actions :defaults => false do |f|
      if current_admin_user.is_super?
        [
        link_to('Visualizar',  admin_evaluation_path(f)), 
        ' ',  
        link_to('Editar',   edit_evaluation_path(f))
        ].reduce(:+).html_safe
      else
        link_to('Visualizar',  admin_evaluation_path(f))
      end
    end
  end

  show do
    attributes_table do
      row :id
      row :user
      row :reviewer
      row :review
      row :created_at
      row :updated_at
    end
  end

  controller do
    def scoped_collection
      super.includes :user, :reviewer
    end
  end

  filter :user
  filter :reviewer
  filter :created_at
  filter :updated_at
end
