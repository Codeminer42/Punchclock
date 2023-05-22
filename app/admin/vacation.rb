# frozen_string_literal: true

ActiveAdmin.register Vacation do
  actions :all, except: [:new, :create]

  permit_params :start_date, :end_date, :status, :user_id, :hr_approver_id, :commercial_approver_id, :denier_id

  menu parent: User.model_name.human(count: 2)

  filter :start_date
  filter :end_date
  filter :user, as: :select, collection: -> { User.includes(:vacations).engineer.active.where.not(vacations: { user: nil } ) }

  member_action :approve, method: :put do
    resource.approve!(current_user)

    if resource.approved?
      VacationMailer.notify_vacation_approved(resource).deliver_later
      VacationMailer.admin_vacation_approved(resource).deliver_later
    end

    redirect_to admin_vacations_path, notice: I18n.t("vacation_approved")
  end

  member_action :denied, method: :put do
    resource.deny!(current_user)
    VacationMailer.notify_vacation_denied(resource).deliver_later
    redirect_to admin_vacations_path(scope: :denied), notice: I18n.t("vacation_denied")
  end

  scope :ongoing_and_scheduled, default: true
  scope :pending
  scope :approved
  scope :denied
  scope :finished
  scope :all

  index do
    column :user
    column :start_date do |vacation|
      l(vacation.start_date, format: :default)
    end
    column :end_date do |vacation|
      l(vacation.end_date, format: :default)
    end
    column :status, &:status_text
    column :hr_approver
    column :commercial_approver
    column :denier

    if authorized? :approve, Vacation
      actions defaults: false do |vacation|
        link_to I18n.t('approve'), approve_admin_vacation_path(vacation), method: :put if vacation.pending?
      end
    end

    if authorized? :denied, Vacation
      actions defaults: false do |vacation|
        link_to I18n.t('refuse'), denied_admin_vacation_path(vacation), method: :put if vacation.pending?
      end
    end
  end
end
