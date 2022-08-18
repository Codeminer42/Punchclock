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
          column(I18n.t('level')) { |allocation| allocation.user.level.humanize }
          column(I18n.t('specialty')) { |allocation| allocation.user.specialty.humanize }
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
  allocation_status = allocation_status_for(last_allocation: last_allocation)

  column_cell_base(
    content: allocation_status_content(
      last_allocation: last_allocation,
      allocation_status: allocation_status
    ),
    allocation_status: allocation_status
  )
end

def allocation_status_content(last_allocation:, allocation_status:)
  return last_allocation.end_at if last_allocation.end_at

  unallocated?(allocation_status) ? I18n.t('not_allocated') : I18n.t('allocated')
end

def unallocated?(allocation_status)
  allocation_status == Status::NOT_ALLOCATED
end

def column_cell_base(content:, allocation_status:)
  div class: "allocated-column__status  allocated-column__status--#{allocation_status}" do
    content
  end
end
