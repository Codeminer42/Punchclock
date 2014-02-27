class PunchesDecorator < Draper::CollectionDecorator
  def total_hours
  	total_hours, total_min = (object.total / 1.minute).divmod( 1.hour / 1.minute )
  	"%02d:%02d" % [total_hours, total_min]
  end
end
