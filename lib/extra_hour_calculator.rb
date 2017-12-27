class ExtraHourCalculator
  MAX_ALLOWED_HOURS = 8
  
  def initialize(user )
    @user = user
  end

  def self.call(user)
    new(user).call 
  end

  def call
    dates = []
    last_month_dates.each do |date|
      dates << date.strftime("%d/%m/%Y") if has_extra_hours_for?(date)
    end

    dates
  end

  private
    
  def has_extra_hours_for?(date)
    (worked_hours_for(date)/60/60).abs > MAX_ALLOWED_HOURS
  end

  def worked_hours_for(date)
    punches_of(date).inject(0) {|sum, punch| sum + (punch.to - punch.from) }
  end

  def punches_of(date)
    @user.punches.by_days date
  end
  
  def today
    @today ||= Time.zone.yesterday
  end

  def one_month_ago
    @one_month_ago ||= (today.prev_month + 1.day)
  end
  
  def last_month_dates
    one_month_ago.to_date..today.to_date
  end
end