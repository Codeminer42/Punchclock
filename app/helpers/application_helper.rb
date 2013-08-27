module ApplicationHelper
  def time_format(hours)
    hour = (hours - hours % 1).to_i.to_s
    mins = ((hours % 1) * 60).to_i
    mins = mins < 10 ? ('0' + mins.to_s) : mins.to_s
    hour + ':' + mins
  end
end
