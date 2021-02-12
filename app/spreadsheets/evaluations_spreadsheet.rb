# frozen_string_literal: true

class EvaluationsSpreadsheet < BaseSpreadsheet
  def body(evaluation)
    [
      evaluation.id,
      evaluation.observation,
      evaluation.score,
      translate_enumerize(evaluation.english_level),
      translate_date(evaluation.created_at),
      translate_date(evaluation.created_at),
      translate_date(evaluation.evaluation_date)
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
      evaluation_date
    ].map { |attribute| Evaluation.human_attribute_name(attribute) }
  end
end
