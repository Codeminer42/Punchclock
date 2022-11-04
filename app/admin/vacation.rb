# frozen_string_literal: true

ActiveAdmin.register Vacation do
  permit_params :start_date, :end_date, :status, :user_id, :commercial_approver_id, :administrative_approver_id

  menu parent: User.model_name.human(count: 2)
  
  filter :start_date
  filter :end_date
  filter :user, as: :select, collection: -> { User.includes(:vacations).engineer.active.where.not(vacations: { user: nil } ) }

  member_action :approve, method: :put do
    resource.set_approver(current_user)
    resource.update(status: :approved) unless resource.commercial_approver.nil? && resource.administrative_approver.nil?
    redirect_to admin_vacations_path
  end

  member_action :denied, method: :put do
    resource.set_approver(current_user)
    resource.update(status: :denied) unless resource.commercial_approver.nil? && resource.administrative_approver.nil?
    redirect_to admin_vacations_path
  end

  scope :all
  scope :pending
  scope :approved
  scope :denied

  index do
    column :user
    column :start_date do |vacation|
      l(vacation.start_date, format: :default)
    end
    column :end_date do |vacation|
      l(vacation.end_date, format: :default)
    end
    column :status do |vacation|
      Vacation.human_attribute_name("status/#{vacation.status}")
    end
    column :commercial_approver
    column :administrative_approver
    actions defaults: false do |vacation|
      link_to I18n.t('approve'), approve_admin_vacation_path(vacation), method: :put if vacation.pending?
    end
    actions defaults: false do |vacation|
      link_to I18n.t('refuse'), denied_admin_vacation_path(vacation), method: :put if vacation.pending?
    end
  end
end
