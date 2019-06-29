# frozen_string_literal: true

ActiveAdmin.register_page "Dashboard" do

  menu priority: 0, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    panel t('search_fields', scope: 'active_admin'), class: 'search-fields' do
      current_company = current_admin_user.company

      users_collection = current_company.users.active.includes(:office).order(:name).map do |user| 
        user_label = "#{user.name.titleize} - #{user.email} - "
        user_label += "#{user.level.humanize} - " if user.engineer?
        user_label += "#{user.office} - #{user.current_allocation.presence || 'Não Alocado'}"

        [user_label, user.id]
      end

      offices_collection = current_company.offices.order(:city).decorate.map do |office| 
        [
          "#{office.city.titleize} - #{office.head} - #{office.score}",
          office.id
        ]
      end


      projects_collection = current_admin_user
                              .company
                              .projects
                              .active
                              .order(:name)
                              .map { |project| [
                                "#{project.name}" \
                                "#{ project.client.try(:name) ? ' - '+project.client.name: '' }",
                                project.id ]}

      render "search_field", search_model: User, url_path: admin_users_path, collection: users_collection
      render "search_field", search_model: Office, url_path: admin_offices_path, collection: offices_collection
      render "search_field", search_model: Project, url_path: admin_projects_path, collection: projects_collection
    end
  end
end
