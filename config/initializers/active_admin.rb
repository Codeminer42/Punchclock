ActiveAdmin.setup do |config|
  config.site_title = 'Punchclock'
  config.authentication_method = :authenticate_admin_user!
  config.current_user_method = :current_admin_user
  config.logout_link_path = :destroy_admin_user_session_path
  config.allow_comments = false
  config.batch_actions = true
  config.csv_options = { col_sep: ';', force_quotes: true }
end
