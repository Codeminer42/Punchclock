class HourReport
  extend ActiveModel::Translation

  attr_reader :project, :user, :hours

  def initialize(project, user, hours)
    @project = project
    @user = user
    @hours = hours
  end

  def self.build_reports_for(user, date_range=DateTime.current.beginning_of_month..DateTime.current.end_of_month)
    current_month_punches = user.punches.where(from: date_range)

    current_month_punches.group_by(&:project).map do |project, punches|
      project_seconds = punches.inject(0) { |acc, punch| acc + punch.delta }
      project_time = RelativeTime.format_seconds_in_hours(project_seconds)
      new(project, user, project_time)
    end
  end
end
