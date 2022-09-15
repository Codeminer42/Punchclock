# frozen_string_literal: true

ActiveAdmin.register Skill do
  permit_params :title

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
      end
    end
    f.actions
  end
end
