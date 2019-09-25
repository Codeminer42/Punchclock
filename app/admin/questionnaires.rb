# frozen_string_literal: true

ActiveAdmin.register Questionnaire do
  permit_params :title, :kind, :active, :description, :company_id,
                questions_attributes: %i[
                  id title kind raw_answer_options _destroy updated_at
                ]

  menu parent: Evaluation.model_name.human(count: 2)

  config.clear_action_items!

  action_item :new, only: :index do
    link_to "#{I18n.t('new')} #{Questionnaire.model_name.human}",
            new_admin_questionnaire_path
  end

  action_item :edit, only: :show, if: -> { questionnaire.evaluations.empty? } do
    link_to "#{I18n.t('edit')} #{Questionnaire.model_name.human}",
            edit_admin_questionnaire_path(questionnaire)
  end

  action_item :destroy, only: :show, if: -> { questionnaire.evaluations.empty? } do
    link_to "#{I18n.t('delete')} #{Questionnaire.model_name.human}",
            admin_questionnaire_path(questionnaire), method: :delete, data: { confirm: 'Are you sure you want to delete this?' }
  end

  action_item :update, only: :show, if: -> { !questionnaire.active? } do
    link_to "#{I18n.t('activate')} #{Questionnaire.model_name.human}",
            toggle_active_admin_questionnaire_path(questionnaire), method: :put
  end

  action_item :update, only: :show, if: -> { questionnaire.active? } do
    link_to "#{I18n.t('deactivate')} #{Questionnaire.model_name.human}",
            toggle_active_admin_questionnaire_path(questionnaire), method: :put
  end

  member_action :toggle_active, method: :put do
    resource.toggle_active
    redirect_to admin_questionnaire_path(resource),
                notice: I18n.t('flash.actions.update.notice',
                              resource_name: Questionnaire.model_name.human)

  end

  filter :title
  filter :active
  filter :kind, as: :select
  filter :created_at

  index do
    column :title do |questionnaire|
      link_to questionnaire.title, admin_questionnaire_path(questionnaire)
    end
    column :kind
    column :active
    column :created_at
    column :updated_at
  end

  show do
    attributes_table do
      row :title
      row :kind
      row :active
      row :description
      row :created_at
      row :updated_at
      row :questions do
        table_for questionnaire.questions do
          column :title
          column :kind
          column :answer_options
        end
      end
    end
  end

  form do |f|
    f.inputs Questionnaire.model_name.human do
      f.input :title
      f.input :kind, as: :select, collection: Questionnaire.kind.values.map { |key| [key.humanize, key] }
      if current_user.super_admin?
        f.input :company
      else
        f.input :company_id, as: :hidden, input_html: { value: current_user.company_id }
      end
      f.input :active
      f.input :description
      f.has_many :questions, allow_destroy: true, new_record: true do |q|
        q.input :title
        q.input :kind
        q.input :company_id, as: :hidden, input_html: { value: current_user.company_id }
        q.input :raw_answer_options, label: 'Answer options separated by ;', input_html: {
          value: q.object.answer_options_to_string,
          autocomplete: 'off'
        }
      end
    end
    f.actions
  end
end
