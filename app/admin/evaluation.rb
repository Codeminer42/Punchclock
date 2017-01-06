ActiveAdmin.register Evaluation do
  actions :index, :show

  index do
    column :user
    column :reviewer
    column :created_at
    column :updated_at
    actions
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
