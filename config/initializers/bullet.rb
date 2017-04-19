if Rails.env.development?
  Bullet.enable = ENV['BULLET_ENABLED'] == "true"
  Bullet.alert = ENV['BULLET_ALERT'] == "true"
  Bullet.bullet_logger = ENV['BULLET_LOGGER'] == "true"
  Bullet.console = ENV['BULLET_CONSOLE'] == "true"
  Bullet.rails_logger = ENV['BULLET_RAILS_LOGGER'] == "true"
  Bullet.add_footer = ENV['BULLET_ADD_FOOTER'] == "true"
end
