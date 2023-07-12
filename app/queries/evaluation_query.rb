# frozen_string_literal: true

class EvaluationQuery
  def initialize(**options)
    @evaluator_id          = options[:evaluator_id]
    @evaluated_id          = options[:evaluated_id]
    @questionnaire_type    = options[:questionnaire_type]
    @created_at_start      = options[:created_at_start]
    @created_at_end        = options[:created_at_end]
    @evaluation_date_start = options[:evaluation_date_start]
    @evaluation_date_end   = options[:evaluation_date_end]
  end

  def call
    query = scope
    merge_options!(query)

    query
  end

  private

  attr_reader :evaluator_id, :evaluated_id, :questionnaire_type, :created_at_start, :created_at_end,
              :evaluation_date_start, :evaluation_date_end

  def scope
    Evaluation
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

  def merge_options!(query)
    query.merge!(by_evaluator(query))
    query.merge!(by_evaluated(query))
    query.merge!(by_questionnaire_type(query))
    query.merge!(by_created_date(query))
    query.merge!(by_evaluation_date(query))
  end

  def by_evaluator(query)
    return query unless evaluator_id.present?

    query.where('evaluator.id = ?', evaluator_id)
  end

  def by_evaluated(query)
    return query unless evaluated_id.present?

    query.where('evaluated.id = ?', evaluated_id)
  end

  def by_questionnaire_type(query)
    return query unless questionnaire_type.present?

    query.where('questionnaires.kind = ?', questionnaire_type)
  end

  def by_created_date(query)
    return query unless created_at_start.present? || created_at_end.present?

    if created_at_start && created_at_end
      query.where(evaluations: { created_at: created_at_start..created_at_end })
    elsif created_at_start
      query.where('evaluations.created_at >= ?', created_at_start)
    elsif created_at_end
      query.where('evaluations.created_at <= ?', created_at_end)
    end
  end

  def by_evaluation_date(query)
    return query unless evaluation_date_start.present? || evaluation_date_end.present?

    if evaluation_date_start && evaluation_date_end
      query.where(evaluations: { evaluation_date: evaluation_date_start..evaluation_date_end })
    elsif evaluation_date_start
      query.where('evaluations.evaluation_date >= ?', evaluation_date_start)
    elsif evaluation_date_end
      query.where('evaluations.evaluation_date <= ?', evaluation_date_end)
    end
  end
end
