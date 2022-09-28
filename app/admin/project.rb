# frozen_string_literal: true

ActiveAdmin.register Project do
  decorate_with ProjectDecorator

  config.sort_order = 'name_asc'

  permit_params :name, :market, :active

  before_action :create_form, :create_project_contact_informations, only: :show

  scope :active, default: true
  scope :inactive

  filter :name
  filter :market, as: :select, collection: Project.market.options
  filter :created_at
  filter :updated_at

  batch_action :destroy, false
  batch_action :disable, if: proc { params[:scope] != "inactive" } do |ids|
    batch_action_collection.find(ids).each(&:disable!)

    redirect_to collection_path, alert: "The projects have been disabled."
  end

  batch_action :enable, if: proc { params[:scope] == "inactive" }  do |ids|
    batch_action_collection.find(ids).each(&:enable!)

    redirect_to collection_path, alert: "The projects have been enabled."
  end

  collection_action :allocate_users, method: :post do
    @allocate_users_form = AllocateUsersForm.new(permited_allocation_params)
    if @allocate_users_form.save
      redirect_to admin_allocations_path, notice: I18n.t('allocate_users_form.success')
    else
      redirect_to admin_project_path(@allocate_users_form.project_id), alert: I18n.t('allocate_users_form.error')
    end
  end

  member_action :project_contact_informations, method: :post do
    @project_contact_informations = ProjectContactInformation.new(permited_project_contact_information_params)
    if @project_contact_informations.save
      redirect_to admin_project_path(@project_contact_informations.project_id),
        notice: I18n.t('project_contact_informations.success')
    else
      redirect_to admin_project_path(@project_contact_informations.project_id),
        alert: I18n.t('project_contact_informations.error', errors: @project_contact_informations.errors.full_messages.join(', '))
    end
  end

  member_action :project_contact_information, method: :delete do
    @project_contact_information = ProjectContactInformation.find(params[:project_contact_information_id])
    @project_contact_information.destroy!
    redirect_to admin_project_path(@project_contact_information.project_id),
      notice: I18n.t('project_contact_informations.delete')
  end

  index download_links: [:xls] do
    selectable_column
    column :name do |project|
      link_to project.name, admin_project_path(project)
    end
    column :market
    column :active
    column :created_at
    actions
  end

  show do
    tabs do
      tab I18n.t('main') do
        attributes_table do
          row :name
          row :market
          row :active
          row :created_at
          row :updated_at
        end

        panel ProjectContactInformation.model_name.human(count: 2) do
          table_for project.project_contact_informations do
            column :name
            column :email
            column :phone
            column :actions do |project_contact_information|
              link_to I18n.t('delete'), project_contact_information_admin_project_path(project_contact_information.project_id, project_contact_information_id: project_contact_information.id), method: :delete
            end
          end
        end

        panel Allocation.model_name.human(count: 2) do
          table_for project.allocations.ongoing do
            column :user
            column :start_at
            column :end_at
            column :access do |allocation|
              link_to I18n.t('view'), admin_allocation_path(allocation)
            end
          end
        end

        panel t('revenue_forecast') do
          data = RevenueForecastService.project_forecast(project)

          # TODO: Refactor
          # * Current year tab should come active as default
          # * Improve how data is being rendered
          # * Implement i18n
          tabs do
            data.each do |year, data|
              tab year.to_s do
                columns do
                  (1..12).each do |month|
                    column do
                      para Date::MONTHNAMES[month]
                      span { data[month] ? humanized_money_with_symbol(data[month]) : '-' }
                    end
                  end
                end
              end
            end # tab
          end # tabs
        end # panel

      end

      tab I18n.t('allocate_users') do
        render 'allocate_users'
      end

      tab I18n.t('project_contact_informations.title') do
        render 'project_contact_informations'
      end
    end
  end

  form do |f|
    f.inputs I18n.t('project_details') do
      f.input :name
      f.input :market
      f.input :active
    end
    f.actions
  end

  controller do
    def create_form
      @allocate_users_form = AllocateUsersForm.new
    end

    def permited_allocation_params
      params.require(:allocate_users_form).permit(:project_id, :start_at, :end_at, :not_allocated_users)
    end

    def create_project_contact_informations
      @project_contact_informations = ProjectContactInformation.new
    end

    def permited_project_contact_information_params
      params.require(:project_contact_information).permit(
        :name, :email, :phone, :project_id
      )
    end

    def index
      super do |format|
        format.xls do
          spreadsheet = ProjectsSpreadsheet.new find_collection(except: :pagination)
          send_data spreadsheet.to_string_io, filename: 'projects.xls'
        end
      end
    end
  end
end
