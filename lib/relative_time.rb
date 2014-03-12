class RelativeTime
  def initialize(time_string)
    @time_relative = time_string.to_time
    @parsed_hours = @time_relative.hour
    @parsed_mins = @time_relative.min
  end

  def relative_to(date)
    date.to_date + @parsed_hours.hours + @parsed_mins.minutes
  end
end
