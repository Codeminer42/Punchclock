ActiveAdmin.register Contribution do
  permit_params :state
  actions :index, :show

  menu parent: Contribution.model_name.human(count: 2), priority: 1

  filter :company, as: :select, if: proc { current_user.super_admin? }
  filter :user, as: :select, collection: proc {
    current_user.super_admin? ? User.engineer.active.order(:name).group_by(&:company) : current_user.company.users.engineer.active.order(:name)
  }
  filter :state, as: :select, collection: Contribution.aasm.states_for_select
  filter :created_at

  member_action :approve, method: :put, only: :index
  member_action :refuse, method: :put, only: :index

  batch_action :refuse, if: proc { params[:scope] != "recusado" && params[:scope] != "aprovado" } do |ids|
    batch_action_collection.find(ids).each {|contribution| contribution.refuse! if contribution.state == "received"}

    redirect_back fallback_location: collection_path, notice: "The contributions have been refused."
  end
  batch_action :approve, if: proc { params[:scope] != "recusado" && params[:scope] != "aprovado" } do |ids|
    batch_action_collection.find(ids).each {|contribution| contribution.approve! if contribution.state == "received"}

    redirect_back fallback_location: collection_path, notice: "The contributions have been approved."
  end
  scope :all, default: true

  scope I18n.t(:this_week), :this_week, group: :time
  scope I18n.t(:last_week), :last_week, group: :time

  scope Contribution.human_attribute_name('state/received'), :received, group: :state
  scope Contribution.human_attribute_name('state/approved'), :approved, group: :state
  scope Contribution.human_attribute_name('state/refused'), :refused, group: :state

  index download_links: [:xls, :text] do
    selectable_column
    column :user
    column :company
    column :link do |contribution|
      link_to contribution.link, contribution.link, target: :blank
    end
    column :created_at
    column :state do |contribution|
      Contribution.human_attribute_name("state/#{contribution.state}")
    end

    actions defaults: true do |contribution|
      if contribution.received?
        item I18n.t('approve'), approve_admin_contribution_path(contribution), method: :put, class: "member_link"
        item I18n.t('refuse'), refuse_admin_contribution_path(contribution), method: :put, class: "member_link"
      end
    end
  end

  show do
    attributes_table do
      row :user
      row :company
      row :link
      row :state do |contribution|
        Contribution.human_attribute_name("state/#{contribution.state}")
      end
      row :created_at
      row :updated_at
    end
  end


  controller do
    def approve
      resource.approve!
      redirect_back fallback_location: resource_path, notice: I18n.t('contribution_approved')
    end

    def refuse
      resource.refuse!
      redirect_back fallback_location: resource_path, notice: I18n.t('contribution_refused')
    end

    def index
      super do |format|
        format.xls do
          spreadsheet = ContributionsSpreadsheet.new find_collection(except: :pagination)
          send_data spreadsheet.to_string_io, filename: "#{Contribution.model_name.human(count: 2)}.xls"
        end
        format.text do
          send_data ContributionsTextService.call(find_collection(except: :pagination))
        end
      end
    end
  end

end