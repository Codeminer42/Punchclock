DateOverlapQuery = Struct.new(:object_class) do
  def contains(date)
    object_class.where contains_exp date
  end

  def intersect(range)
    object_class.where contains_exp(range.min).or contains_exp range.max
  end

  private

  def contains_exp(date)
    t[:start_at].lt(date).and t[:end_at].gt(date)
  end

  def t
    object_class.arel_table
  end
end
