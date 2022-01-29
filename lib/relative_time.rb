class RelativeTime
  def initialize(time_string)
    @time_relative = time_string.to_time
    @parsed_hours = @time_relative.hour
    @parsed_mins = @time_relative.min
  end

  def relative_to(date)
    date.to_date + @parsed_hours.hours + @parsed_mins.minutes
  end

  def self.format_seconds_in_hours(seconds)
    hours = seconds.div(1.hour)
    minutes = (seconds % 1.hour).div(1.minute)

    if minutes == 0
      "#{hours}H"
    else
      "#{hours}H#{minutes}M"
    end
  end
end
