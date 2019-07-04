# frozen_string_literal: true
pre_defined_paths = Rails.application.config.i18n.load_path

ActiveAdmin.setup do |config|
  config.site_title = proc {
    (!admin_user_signed_in? || current_admin_user.super_admin?) ? "Punchclock" : "Punchclock (#{current_admin_user.company})"
  }

  config.download_links = [:csv]
  config.authentication_method = :authenticate_admin_user!
  config.current_user_method = :current_admin_user
  config.logout_link_path = :destroy_admin_user_session_path
  config.comments = false
  config.batch_actions = true
  config.csv_options = { col_sep: ';', force_quotes: true }
  config.authorization_adapter = ActiveAdmin::CanCanAdapter

  # == Menu System
  config.namespace :admin do |admin|
    admin.build_menu do |menu|
      menu.add label: User.model_name.human(count: 2) do |submenu|
        submenu.add label: 'Não alocados', url: '/admin/users?scope=not_allocated', priority: 2
      end
    end
  end
end


# Hotfix for https://github.com/gregbell/active_admin/issues/434
I18n.enforce_available_locales = false
I18n.default_locale = Rails.application.config.i18n.default_locale
I18n.load_path += pre_defined_paths
I18n.reload!
