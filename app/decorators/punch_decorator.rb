class PunchDecorator < ApplicationDecorator
  delegate_all

  def to
    localize_date_time(object.to)
  end

  def from
    localize_date_time(object.from)
  end

  def delta
    I18n.l Time.at(object.delta), format: '%H:%M'
  end

  private

  def localize_date_time(datetime)
    I18n.l datetime, format: :short
  end
  
end
