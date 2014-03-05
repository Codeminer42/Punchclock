class PunchesDecorator < Draper::CollectionDecorator
  def total_hours
  	h.secs_to_formated_hour(object.total)
  end
end
