# frozen_string_literal: true

ActiveAdmin.register Skill do
  permit_params :title, :company_id

  menu parent: User.model_name.human(count: 2), priority: 5

  config.sort_order = 'title_asc'

  filter :title

  index do
    column :title do |skill|
      link_to skill.title, admin_skill_path(skill)
    end
  end

  form do |f|
    f.inputs "Skills details" do
      f.input :title
      if current_admin_user.super_admin?
        f.input :company
      else
        f.input :company_id, as: :hidden, input_html: { value: current_admin_user.company_id }
      end
    end
    f.actions
  end
end
