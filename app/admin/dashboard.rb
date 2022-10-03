# frozen_string_literal: true

ActiveAdmin.register_page "Dashboard" do

  menu priority: 0, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    panel t('search_fields', scope: 'active_admin'), class: 'search-fields' do

      users_collection = User.active.includes(:office).order(:name).map do |user|
        user_label = "#{user.name.titleize} - #{user.email} - "
        user_label += "#{user.level.humanize} - " if user.engineer?
        user_label += "#{user.office} - #{user.current_allocation.presence || 'Não Alocado'}"

        [user_label, user.id]
      end

      offices_collection = Office.active.order(:city).decorate.map do |office|
        [
          "#{office.city.titleize} - #{office.head} - #{office.score}",
          office.id
        ]
      end

      projects_collection = Project.active.order(:name).map do |project|
        [ project.name, project.id ]
      end

      tabs do
        tab User.model_name.human do
          render "search_field", search_model: User, url_path: admin_users_path, collection: users_collection
        end

        tab Office.model_name.human do
          render "search_field", search_model: Office, url_path: admin_offices_path, collection: offices_collection
        end

        tab Project.model_name.human do
          render "search_field", search_model: Project, url_path: admin_projects_path, collection: projects_collection
        end
      end
    end

    columns do
      column do
        panel t(I18n.t('average_score'), scope: 'active_admin'), class: 'average-score' do
          table_for User.level.values do
            column(User.human_attribute_name(:level)) { |level| User.human_attribute_name(level) }
            column(I18n.t('users_average')) { |level| User.with_level(level).overall_score_average }
          end
        end
      end

      column do
        panel t(I18n.t('offices_leaderboard'), scope: 'active_admin') do
          collection = ContributionsByOfficeQuery.new.leaderboard.this_week.approved

          unless collection.to_relation.empty?
            table_for collection.to_relation do
              column(Office.human_attribute_name(:city)) { |office| office.city }
              column(I18n.t('this_week_contributions')) { |office| office.number_of_contributions }
              column(I18n.t('last_week_contributions')) { |office| ContributionsByOfficeQuery
                                                                    .new(Office.where(city: office.city))
                                                                    .n_weeks_ago(1)
                                                                    .approved
                                                                    .to_relation
                                                                    .first
                                                                    &.number_of_contributions || 0 }
            end
          else
            blank_slate(I18n.t("active_admin.blank_slate.content", resource_name: Contribution.model_name.human(count: 2)))
          end
        end
      end
    end
  end
end
