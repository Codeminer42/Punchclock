# frozen_string_literal: true

module ApplicationHelper
  def gravatar_for(user, options = { size: 50, css_class: '' })
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url =
      "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar #{options[:css_class]}")
  end
end
