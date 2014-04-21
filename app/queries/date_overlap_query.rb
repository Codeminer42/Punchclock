class DateOverlapQuery < BaseQuery
  def contains(date)
    model.where wrap date
  end

  def intersect(range)
    model.where wrap(range.min).or wrap range.max
  end

  private

  def wrap(date)
    t[:start_at].lteq(date).and t[:end_at].gt(date)
  end
end
