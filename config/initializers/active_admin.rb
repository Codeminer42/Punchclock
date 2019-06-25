# frozen_string_literal: true
pre_defined_paths = Rails.application.config.i18n.load_path

ActiveAdmin.setup do |config|
  config.site_title = proc {
    (!admin_user_signed_in? || current_admin_user.is_super?) ? "Punchclock" : "Punchclock (#{current_admin_user.company})"
  
  }

  config.download_links = [:csv, :json]
  config.authentication_method = :authenticate_admin_user!
  config.current_user_method = :current_admin_user
  config.logout_link_path = :destroy_admin_user_session_path
  config.comments = false
  config.batch_actions = true
  config.csv_options = { col_sep: ';', force_quotes: true }
  config.root_to = 'admin_users#index'
  config.authorization_adapter = ActiveAdmin::CanCanAdapter

  # == Menu System
  config.namespace :admin do |admin|
    admin.build_menu do |menu|
      menu.add label: User.model_name.human(count: 2) do |submenu|
        submenu.add label: 'Não Alocados', url: '/admin/users?scope=not_allocated', priority: 2
      end
    end
  end
end


# Hotfix for https://github.com/gregbell/active_admin/issues/434
I18n.enforce_available_locales = false
I18n.default_locale = Rails.application.config.i18n.default_locale
I18n.load_path += pre_defined_paths
I18n.reload!

# ActiveAdmin.setup do |config|
  # config.site_title = "Miner Camp"
  # config.authentication_method = :authenticate_miner!

  # config.authorization_adapter = 'OnlyAdmins'

  # config.on_unauthorized_access = :access_denied
  # config.current_user_method = :current_miner

  # config.logout_link_path = :destroy_miner_session_path

  # config.localize_format = :long

  # == Menu System
  #
  # config.namespace :admin do |admin|
  #   admin.build_menu do |menu|
  #     menu.add label: 'Miners' do |submenu|
  #       submenu.add label: 'Available', url: '/admin/miners?scope=not_allocated'
  #     end
  #   end

  #   admin.build_menu do |menu|
  #     menu.add label: 'Customers' do |submenu|
  #       submenu.add label: 'New Customer', url: '/admin/customers/new'
  #     end
  #   end

  #   admin.build_menu :utility_navigation do |menu|
  #     menu.add label: 'Evaluation Page', url: '/'
  #     admin.add_current_user_to_menu  menu
  #     admin.add_logout_button_to_menu menu
  #   end
  # end
# end
