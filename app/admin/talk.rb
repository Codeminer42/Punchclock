# frozen_string_literal: true

ActiveAdmin.register Talk do
  decorate_with TalkDecorator

  permit_params :event_name, :talk_title, :date, :user_id

  menu parent: [User.model_name.human(count: 2), I18n.t("active_admin.experience")], priority: 2

  config.sort_order = 'event_name_asc'

  filter :user, as: :select
  filter :event_name
  filter :talk_title
  filter :date

  form do |f|
    user = f.object.user_id || params[:user_id]
    f.inputs do
      f.input :user, as: :select, collection: User.active.order(:name), selected: user
      f.input :event_name, placeholder: 'RailsConf'
      f.input :talk_title, placeholder: 'A Rails Performance Guidebook'
      f.input :date, as: :string, input_html: { class: :datepicker }, placeholder: '2021-11-01'
    end
    f.actions
  end
end
