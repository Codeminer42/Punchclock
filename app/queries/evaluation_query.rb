# frozen_string_literal: true

class EvaluationQuery
  def initialize(relation = Evaluation)
    @relation = relation
  end

  def call
    relation
      .select('
        evaluations.*,
        evaluated.name as evaluated,
        evaluator.name as evaluator,
        questionnaires.title as questionnaire
      ')
      .joins(:questionnaire)
      .joins('
        INNER JOIN users as evaluator ON evaluator.id = evaluations.evaluator_id
        INNER JOIN users as evaluated ON evaluated.id = evaluations.evaluated_id
      ')
  end

  private

  attr_reader :relation
end
