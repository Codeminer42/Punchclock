class User < ApplicationRecord
  belongs_to :office, optional: true
  belongs_to :company
  belongs_to :reviewer, class_name: :User, foreign_key: :reviewer_id, optional: true
  has_many :punches

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :name, presence: true
  validates :email, uniqueness: true, presence: true

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  delegate :regional_holidays, to: :office, allow_nil: true

  enum role: %i(trainee junior pleno senior)

  def disable!
    update!(active: false)
  end

  def enable!
    update!(active: true)
  end

  def active_for_authentication?
    super && active?
  end

  def inactive_message
    active? ? super : :inactive_account
  end

  def to_s
    name
  end
end
