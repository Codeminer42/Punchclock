pre_defined_paths = Rails.application.config.i18n.load_path

ActiveAdmin.setup do |config|
  config.site_title = proc {
    (!admin_user_signed_in? || current_admin_user.is_super?) ? "Punchclock" : "Punchclock (#{current_admin_user.company})"

  }

  config.authentication_method = :authenticate_admin_user!
  config.current_user_method = :current_admin_user
  config.logout_link_path = :destroy_admin_user_session_path
  config.comments = false
  config.batch_actions = true
  config.csv_options = { col_sep: ';', force_quotes: true }
  config.root_to = 'admin_users#index'
  config.authorization_adapter = ActiveAdmin::CanCanAdapter
end


# Hotfix for https://github.com/gregbell/active_admin/issues/434
I18n.enforce_available_locales = false
I18n.default_locale = Rails.application.config.i18n.default_locale
I18n.load_path += pre_defined_paths
I18n.reload!
