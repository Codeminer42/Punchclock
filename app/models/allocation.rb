# frozen_string_literal: true

class Allocation < ApplicationRecord
  belongs_to :user
  belongs_to :project
  belongs_to :company

  validates :user, :project, presence: true
  validates_date :start_at

  delegate :office_name, to: :user

  def days_until_finish
    return unless end_at

    end_at > Date.current ? (end_at - Date.current).to_i : I18n.t('finished')
  end
end
