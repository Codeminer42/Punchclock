# frozen_string_literal: true

ActiveAdmin.register Evaluation do
  permit_params :evaluator_id, :evaluated_id, :company_id
  actions :index, :show

  menu parent: Evaluation.model_name.human(count: 2)

  filter :evaluator, collection: proc {
    current_user.super_admin? ? User.all.order(:name).group_by(&:company) : current_user.company.users.active.order(:name)
  }
  filter :evaluated, collection: proc {
    current_user.super_admin? ? User.all.order(:name).group_by(&:company) : current_user.company.users.active.order(:name)
  }
  filter :questionnaire_kind, as: :select, collection: Questionnaire.kind.values.map { |kind| [kind.text.titleize, kind] }
  filter :created_at

  index download_links: [:xls] do
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

  controller do
    def index
      super do |format|
        format.xls do
          spreadsheet = EvaluationsSpreadsheet.new find_collection(except: :pagination)
          send_data spreadsheet.to_string_io, filename: 'evaluations.xls'
        end
      end
    end
  end
end
