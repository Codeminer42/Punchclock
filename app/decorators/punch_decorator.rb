class PunchDecorator < ApplicationDecorator
  delegate_all

  def summary
    "#{from} - #{to}"
  end

  alias_method :to_s, :summary

  def date
    localize_date(object.to)
  end

  def to
    localize_time(object.to)
  end

  def from
    localize_time(object.from)
  end

  def when
    h.l object.from, format: '%d/%m/%Y'
  end

  def delta
    h.secs_to_formated_hour(object.delta)
  end

  def delta_in_hours
    object.delta / 1.hour
  end

  private

  def localize_date_time(datetime)
    h.l datetime, format: :short
  end

  def localize_time(datetime)
    h.l datetime, format: '%H:%M'
  end

  def localize_date(datetime)
    h.l datetime.to_date
  end
end
