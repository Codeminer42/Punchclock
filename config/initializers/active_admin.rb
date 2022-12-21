# frozen_string_literal: true

require_relative Rails.root / 'app/models/ability_admin'

pre_defined_paths = Rails.application.config.i18n.load_path

ActiveAdmin.setup do |config|
  config.site_title = 'Punchclock'

  config.download_links = false
  config.authentication_method = :authenticate_admin_user!
  config.current_user_method = :current_user
  config.logout_link_path = :destroy_user_session_path
  config.comments = false
  config.batch_actions = true
  config.authorization_adapter = ActiveAdmin::CanCanAdapter
  config.cancan_ability_class = AbilityAdmin
  config.on_unauthorized_access = :access_denied
end

# Hotfix for https://github.com/gregbell/active_admin/issues/434
I18n.enforce_available_locales = false
I18n.default_locale = Rails.application.config.i18n.default_locale
I18n.load_path += pre_defined_paths
I18n.reload!
