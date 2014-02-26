class PunchDecorator < ApplicationDecorator
  delegate_all

  def date
    localize_date(object.to)
  end

  def to
    localize_time(object.to)
  end

  def from
    localize_time(object.from)
  end

  def delta
   TimeDelta.new(object.delta)
  end

  private

  def localize_date_time(datetime)
    h.l datetime, format: :short
  end

  def localize_time(datetime)
    h.l datetime, format: "%H:%M"
  end
  
  def localize_date(datetime)
    h.l datetime, format: :short
  end
end
