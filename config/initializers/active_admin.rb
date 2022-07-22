# frozen_string_literal: true

require_relative Rails.root / 'app/models/ability_admin'

pre_defined_paths = Rails.application.config.i18n.load_path

ActiveAdmin.setup do |config|
  config.site_title = proc {
    !user_signed_in? || current_user.super_admin? ? 'Punchclock' : "Punchclock (#{current_user.company})"
  }

  config.download_links = [:csv]
  config.authentication_method = :authenticate_admin_user!
  config.current_user_method = :current_user
  config.logout_link_path = :destroy_user_session_path
  config.comments = false
  config.batch_actions = true
  config.csv_options = { col_sep: ';', force_quotes: true }
  config.authorization_adapter = ActiveAdmin::CanCanAdapter
  config.cancan_ability_class = AbilityAdmin
  config.on_unauthorized_access = :access_denied

  # == Menu System
  config.namespace :admin do |admin|
    admin.build_menu do |menu|
      menu.add label: User.model_name.human(count: 2) do |submenu|
        submenu.add label: I18n.t('active_admin.resources.user.scopes.not_allocated'), 
                    url: '/admin/users?scope=not_allocated', 
                    priority: 2, 
                    if: proc { current_user.is_admin? }
      end
    end
  end
end

# Hotfix for https://github.com/gregbell/active_admin/issues/434
I18n.enforce_available_locales = false
I18n.default_locale = Rails.application.config.i18n.default_locale
I18n.load_path += pre_defined_paths
I18n.reload!
