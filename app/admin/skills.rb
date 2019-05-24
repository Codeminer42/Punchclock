# frozen_string_literal: true

ActiveAdmin.register Skill do
  permit_params :title, :company_id

  menu parent: I18n.t("activerecord.models.user.other"), priority: 5

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
      if current_admin_user.is_super?
        f.input :company
      else
        f.input :company_id, as: :hidden, input_html: { value: current_admin_user.company_id }
      end
    end
    f.actions
  end
end
