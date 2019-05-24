# frozen_string_literal: true

class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :company, optional: true
  validates :email, presence: true
  validates :company_id, presence: true, unless: :is_super?

  scope :not_super, -> { where(is_super: [nil, false]) }

  def to_s
    email
  end
end
