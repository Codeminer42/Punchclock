ActiveAdmin.register Contribution do
  decorate_with ContributionDecorator

  permit_params :state, :link, :user_id, :repository_id, :rejected_reason
  actions :index, :show, :new, :create, :edit, :update

  menu parent: Contribution.model_name.human(count: 2), priority: 1

  filter :user, as: :select, collection: -> { User.engineer.active.order(:name) }
  filter :state, as: :select, collection: -> { Contribution.aasm.states }
  filter :reviewed_at
  filter :created_at

  member_action :approve, method: :put, only: :index
  member_action :refuse, method: :put, only: :index

  batch_action :refuse, if: proc { params[:scope] != "recusado" && params[:scope] != "aprovado" } do |ids|
    batch_action_collection.find(ids).each { |contribution|
      if contribution.received?
        contribution.refuse!(current_user.id)
        contribution.update(rejected_reason: :other_reason)
      end
    }

    redirect_back fallback_location: collection_path, notice: "The contributions have been refused."
  end
  batch_action :approve, if: proc { params[:scope] != "recusado" && params[:scope] != "aprovado" } do |ids|
    batch_action_collection.find(ids).each { |contribution| contribution.approve!(current_user.id) if contribution.received? }

    redirect_back fallback_location: collection_path, notice: "The contributions have been approved."
  end

  batch_action :send_to_newsletter do |ids|
    contributions = ContributionsTextService.call(Contribution.where(id: ids))
    NotificationMailer.notify_newsletter_contributions(contributions).deliver
    redirect_back fallback_location: collection_path, notice: I18n.t('contributions_sent_to_newsletter')
  end

  scope :all, :active_engineers, default: true

  scope I18n.t(:this_week), :this_week, group: :time
  scope I18n.t(:last_week), :last_week, group: :time

  scope Contribution.human_attribute_name('state/received'), :received, group: :state
  scope Contribution.human_attribute_name('state/approved'), :approved, group: :state
  scope Contribution.human_attribute_name('state/refused'), :refused, group: :state

  index download_links: [:xlsx, :text] do
    selectable_column
    column :user do |contribution|
      link_to contribution.user.first_and_last_name, admin_user_path(contribution.user)
    end
    column :link do |contribution|
      link_to contribution.link, contribution.link, target: :blank
    end
    column :created_at
    column :state do |contribution|
      Contribution.human_attribute_name("state/#{contribution.state}")
    end
    column :pr_state, &:pr_state_text
    column :reviewed_by, &:reviewed_by_short_name
    column :reviewed_at
    column :rejected_reason do |contribution|
      contribution.rejected_reason_text
    end

    actions defaults: true do |contribution|
      if contribution.received?
        item I18n.t('approve'), approve_admin_contribution_path(contribution), method: :put, class: "member_link"
        content_tag("a", I18n.t('refuse'), class: "member_link_refuse", name: "refuse_contribution", data: { id: contribution.id, reasons: Contribution.rejected_reason.options })
      end
    end
  end

  show do
    attributes_table do
      row :user
      row :link
      row :state do |contribution|
        Contribution.human_attribute_name("state/#{contribution.state}")
      end
      row :rejected_reason do |contribution|
        contribution.rejected_reason_text
      end
      row :pr_state
      row :reviewed_by
      row :reviewed_at
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors
    inputs I18n.t('contribution_details') do
      if f.object.persisted?
        input :state, collection: Contribution.aasm.states
        input :rejected_reason, as: :select, collection: Contribution.rejected_reason.values.map { |reason| [I18n.t(reason, scope: 'enumerize.contribution.rejected_reason'), reason] }
      else
        input :user, as: :select, collection: User.engineer.active.order(:name)

        input :repository, collection: RepositoriesOrderedByContributionsQuery.new.call
        input :link
      end
    end
    f.actions
  end

  controller do
    def approve
      resource.approve!(current_user.id)
      redirect_back fallback_location: resource_path, notice: I18n.t('contribution_approved')
    end

    def refuse
      resource.refuse!(current_user.id)
      resource.update(rejected_reason: params["rejected_reason"])
      redirect_back fallback_location: resource_path, notice: I18n.t('contribution_refused')
    end

    def index
      super do |format|
        format.xlsx do
          spreadsheet = ContributionsSpreadsheet.new find_collection(except: %i[pagination collection_decorator])
          send_data spreadsheet.to_string_io, filename: "#{Contribution.model_name.human(count: 2)}.xlsx"
        end
        format.text do
          send_data ContributionsTextService.call(find_collection(except: %i[pagination collection_decorator]))
        end
      end
    end
  end
end
