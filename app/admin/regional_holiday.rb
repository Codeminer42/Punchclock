ActiveAdmin.register RegionalHoliday do
  permit_params :name, :day, :month, office_ids: []

  index do
    column :id
    column :name
    column :day
    column :month
    column :offices do |holiday|
      offices_by_holiday(holiday)
    end
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :day
      row :month
      row :offices do |holiday|
        offices_by_holiday(holiday)
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :day
      f.input :month
      f.input :offices, as: :check_boxes
      f.actions
    end
  end
end
