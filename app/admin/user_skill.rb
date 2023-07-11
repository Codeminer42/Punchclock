# frozen_string_literal: true

ActiveAdmin.register UserSkill do
  menu parent: User.model_name.human(count: 2)
  actions :all, except: %i[show]

  filter :user, collection: -> { User.engineer.active.order(:name) }
  filter :skill
  filter :experience_level, as: :select, options: UserSkill.experience_level.options

  permit_params :user_id, :skill_id, :experience_level

  index do
    selectable_column
    column :user
    column :skill
    column :experience_level
    actions
  end

  form html: { autocomplete: 'off' } do |_|
    inputs do
      users = User.engineer.active.order(:name).select(:id, :name)
      input :user, as: :select, collection: users

      input :skill
      input :experience_level
    end

    actions
  end
end
