# frozen_string_literal: true

include ActiveAdmin::StatsHelper

def contributions_by_offices(month)
  query = ContributionsByOfficeQuery.new.approved
  relation = month.empty? ? query.to_relation : query.per_month(month.to_i).to_relation
  ActiveAdmin::StatsHelper.constributions_offices_data(relation)
end

def contributions_by_users(month)
  query = ContributionsByUserQuery.new.approved
  limitQuantity = 5

  per_users = month.empty? ? query.to_hash : query.per_month(month.to_i).to_hash
  ActiveAdmin::StatsHelper.constributions_users_data(
    contributions: per_users,
    limit: limitQuantity
  )
end

ActiveAdmin.register_page 'Stats' do
  page_action :show, method: :get do
    month = params[:month]

    return render json: contributions_by_users(month) if params[:by_user]

    render json: contributions_by_offices(month)
  end

  menu parent: Contribution.model_name.human(count: 2), priority: 3,
       label: proc { I18n.t('stats') }

  content title: proc { I18n.t('stats') } do
    @months = I18n.t('date.month_names').drop(1).map(&:capitalize).zip(1..12).take(Date.today.month)

    relation = ContributionsByOfficeQuery.new.approved.to_relation
    @stats = ActiveAdmin::StatsHelper.constributions_offices_data(relation)
    @max = @stats.values.max
    
    per_users = ContributionsByUserQuery.new.approved.to_hash
    @per_user_stats = ActiveAdmin::StatsHelper.constributions_users_data(
      contributions: per_users,
      limit: 5
    )
    @per_user_max = @per_user_stats.values.max
    
    panel t('search_fields', scope: 'active_admin'), class: 'search-fields' do
      render "search_field", collection: @months
    end

    columns do
      column do
      end

      column do
        panel I18n.t('contributions_by_office') do
          div do
            hidden_field_tag 'max', @max
          end

          div id: 'graph-by-office-div', style: 'height: 300px;' do
            column_chart @stats, max: @max
          end
        end
      end

      column do
        panel I18n.t('contributions_by_user') do
          div do
            hidden_field_tag 'per_user_max', @per_user_max
          end

          div id: 'graph-by-user-div', style: 'height: 300px;' do
            column_chart @per_user_stats, max: @per_user_max
          end
        end
      end
    end
  end
end
