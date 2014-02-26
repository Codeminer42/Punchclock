class TimeDelta < Numeric
  def initialize(difference)
    @hours, @minutes = (difference / 1.minute).divmod( 1.hour / 1.minute )
  end

  def to_s
    "%02d:%02d" % [@hours, @minutes]
  end

  def to_a
  	[@hours, @minutes]
  end

  def inspect
    to_s
  end
end