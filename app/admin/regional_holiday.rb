ActiveAdmin.register RegionalHoliday do

  index do
    column :id
    column :name
    column :day
    column :month
    column :offices do |holiday|
      offices_by_holiday(holiday)
    end
    actions :defaults => false do |f|
      if current_admin_user.is_super?
        [
        link_to('Visualizar', admin_regional_holiday_path(f)), 
        ' ',  
        link_to('Editar',  edit_admin_regional_holiday_path(f)),
        ' ',
        link_to('Deletar', admin_regional_holiday_path(f), data: { confirm: 'Are you sure?' }, :method => :delete)
        ].reduce(:+).html_safe
      else
        link_to('Visualizar', admin_regional_holiday_path(f))
      end
    end
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
      f.input :offices

      f.actions
    end
  end

  controller do
    def permitted_params
      params.permit(regional_holiday: [:name, :day, :month, office_ids: []])
    end
  end
end
