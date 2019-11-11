# frozen_string_literal: true

class EvaluationsSpreadsheet < BaseSpreadsheet
  def body(evaluation)
    [
      evaluation.id,
      evaluation.observation,
      evaluation.score,
      evaluation.english_level.text,
      I18n.l(evaluation.created_at, format: :long),
      I18n.l(evaluation.created_at, format: :long)
    ]
  end

  def header
    %w[
      id
      observation
      score
      english_level
      created_at
      updated_at
    ].map { |attribute| Evaluation.human_attribute_name(attribute) }
  end
end
