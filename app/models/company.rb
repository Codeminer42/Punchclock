# frozen_string_literal: true

class Company < ApplicationRecord
  has_many :projects
  has_many :users
  has_many :punches
  has_many :offices
  has_many :clients
  has_many :regional_holidays, through: :offices

  has_many :allocations
  has_many :questionnaires
  has_many :evaluations
  has_many :skills


  validates :name, presence: true

  mount_uploader :avatar, CompanyAvatarUploader

  def to_s
    name
  end
end
