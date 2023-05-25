# frozen_string_literal: true

ActiveAdmin.register Talk do
  permit_params :event_name, :talk_title, :date, :user_id

  menu parent: User.model_name.human(count: 2)

  config.sort_order = 'event_name_asc'

  filter :user, as: :select
  filter :event_name
  filter :talk_title
  filter :date

  form do |f|
    f.inputs do
      f.input :user, as: :select, collection: User.active.order(:name)
      f.input :event_name
      f.input :talk_title
      f.input :date, as: :datetime_picker
    end
    f.actions
  end
end
