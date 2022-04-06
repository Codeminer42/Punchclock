# frozen_string_literal: true

class EvaluationsSpreadsheet < BaseSpreadsheet
  def body(evaluation)
    [
      evaluation.id,
      evaluation.evaluator.name,
      evaluation.evaluated.name,
      evaluation.evaluated.email,
      evaluation.observation,
      evaluation.score,
      translate_enumerize(evaluation.english_level),
      evaluation.questionnaire.title,
      evaluation.questionnaire.kind,
      translate_date(evaluation.created_at),
      translate_date(evaluation.created_at),
      translate_date(evaluation.evaluation_date)
    ]
  end

  def header
    %w[
      id
      evaluator
      evaluated
      evaluated_email
      observation
      score
      english_level
      questionnaire
      questionnaire_kind
      created_at
      updated_at
      evaluation_date
    ].map { |attribute| Evaluation.human_attribute_name(attribute) }
  end
end
