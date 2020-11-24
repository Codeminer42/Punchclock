# frozen_string_literal: true

include ActiveAdmin::StatsHelper
ActiveAdmin.register_page 'Stats' do
  page_action :show do
    query = ContributionsByOfficeQuery.new.by_company(current_user.company).approved
    relation = params[:month].empty? ? query.to_relation : query.per_month(params[:month].to_i).to_relation
    @stats = ActiveAdmin::StatsHelper.stats_data(relation)
    render json: @stats
  end

  menu parent: Contribution.model_name.human(count: 2), priority: 3,
       label: proc { I18n.t('stats') }

  content title: proc { I18n.t('stats') } do
    @months = I18n.t('date.month_names').drop(1).zip(1..12).take(Date.today.month)
    relation = ContributionsByOfficeQuery.new.by_company(current_user.company).approved.to_relation
    @stats = ActiveAdmin::StatsHelper.stats_data(relation)
    @max = @stats.values.max

    columns do
      column do
      end

      column do
        panel I18n.t('contributions_by_office') do
          div do
            hidden_field_tag 'max', @max
          end

          div do
            semantic_form_for 'stats', url: '#' do |f|
              f.input :month, label: false, required: false, as: :select,
                              prompt: I18n.t('filter_by_month'),
                              wrapper_html: { style: 'display: grid;' },
                              input_html: { style: 'font-size: 15px;
                                  font-weight: bold;
                                  margin-bottom: 10px;',
                                            id: 'month-selector' },
                              collection: @months
            end
          end

          div id: 'graph-div', style: 'height: 300px;' do
            column_chart @stats, max: @max
          end
        end
      end
    end
  end
end
