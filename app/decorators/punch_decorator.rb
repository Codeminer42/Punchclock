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

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end
