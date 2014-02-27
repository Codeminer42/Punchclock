module PunchesHelper
    
  def secs_to_formated_hour(difference)
    @hours, @minutes = (difference / 1.minute).divmod( 1.hour / 1.minute )
    "%02d:%02d" % [@hours, @minutes]
  end

end
