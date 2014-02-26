class PunchesDecorator < Draper::CollectionDecorator
  def total_hours
  	object.total / 1.hours
  end
end
