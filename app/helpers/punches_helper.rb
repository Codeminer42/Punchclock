module PunchesHelper
  def secs_to_formated_hour(difference_in_secs)
  minutes_in_1_hour = 1.hour / 1.minute
  difference_in_mins = difference_in_secs / 1.minute
    
  "%02d:%02d" % difference_in_mins.divmod(minutes_in_1_hour)
  end
end
