# frozen_string_literal: true

include ActiveAdmin::AllocationChartHelper

ActiveAdmin.register_page 'Allocation Chart' do
  menu label: proc { I18n.t('allocation_chart') }, parent: User.model_name.human(count: 2)

  content title: I18n.t('allocation_chart') do
    panel I18n.t('allocation_chart') do
      allocations = AllocationsAndUnalocatedUsersQuery.new(Allocation, current_user.company).call
      paginated_collection(allocations.page(params[:page]), download_links: false) do
        table_for collection do
          column(I18n.t('name'), :user)
          column(I18n.t('skills')) { |allocation| allocation.user.skills.map(&:title).join(', ') }
          column(I18n.t('client'), :project)
          column(I18n.t('allocated_until'), class: 'allocated-column') do |allocation|
            build_allocation_status_cell(allocation)
          end
        end
      end
    end
  end
end

def build_allocation_status_cell(last_allocation)
  allocation_status = ActiveAdmin::AllocationChartHelper.allocation_status_for(last_allocation: last_allocation)

  unless last_allocation.end_at.nil?
    return column_cell_base(content: last_allocation.end_at, allocation_status: allocation_status)
  end

  content = if allocation_status == ActiveAdmin::AllocationChartHelper::Status::NOT_ALLOCATED
              I18n.t('not_allocated')
            else
              I18n.t('allocated')
            end

  column_cell_base(content: content, allocation_status: allocation_status)
end

def column_cell_base(content:, allocation_status:)
  div class: "allocated-column__status  allocated-column__status--#{allocation_status}" do
    content
  end
end
