# frozen_string_literal: true

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
          column(I18n.t('allocated_until'), :end_at)
        end
      end
    end
  end
end
