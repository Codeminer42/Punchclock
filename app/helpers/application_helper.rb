module ApplicationHelper
  def gravatar_for(user, options = { size: 50 })
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url =
      "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: 'gravatar')
  end

  def national_holidays
    from = Date.today.beginning_of_year
    to = Date.today.end_of_year
    Holidays.between(from, to, :br, :informal).map do |holiday|
      [holiday[:date].month, holiday[:date].day]
    end
  end
end
