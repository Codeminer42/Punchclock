module ApplicationHelper
  def time_format(hours)
    hours *=  60
    hours = hours.to_int
    hour = (hours / 60).to_s
    mins = (hours % 60)
    mins = mins < 10 ? ('0' + mins.to_s) : mins.to_s
    hour + ':' + mins
  end

  def gravatar_for(user, options = {size:50})
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
