# frozen_string_literal: true

class QuestionnairesSpreadsheet < DefaultSpreadsheet
  def body(questionnaire)
    [
      questionnaire.id,
      questionnaire.title,
      questionnaire.kind,
      questionnaire.description,
      questionnaire.active,
      translate_date(questionnaire.created_at),
      translate_date(questionnaire.updated_at)
    ]
  end

  def header
    %w[
      id
      title
      kind
      description
      active
      created_at
      updated_at
    ].map { |attribute| Questionnaire.human_attribute_name(attribute) }
  end
end
