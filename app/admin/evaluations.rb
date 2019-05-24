# frozen_string_literal: true

ActiveAdmin.register Evaluation do
  permit_params :evaluator_id, :evaluated_id, :company_id
  actions :index, :show

  menu parent: I18n.t("activerecord.models.evaluation.other")

  filter :evaluator
  filter :evaluated
  filter :questionnaire_kind, as: :select, collection: Questionnaire.kinds.keys
  filter :created_at

  index do
    column :evaluator
    column :evaluated
    column :score
    column :questionnaire
    column :created_at

    actions
  end

  show do
    attributes_table do
      row :score
      row :english_level
      row :evaluator
      row :evaluated
      row :created_at
      row :questionnaire
      row :observation
      row :answers do
        table_for evaluation.answers do
          column :question
          column :response
        end
      end
    end
  end
end
