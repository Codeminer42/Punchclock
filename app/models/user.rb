class User < ActiveRecord::Base
  belongs_to :office
  belongs_to :company
  belongs_to :reviewer, class_name: :User, foreign_key: :reviewer_id
  has_many :punches

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :name, presence: true
  validates :email, uniqueness: true, presence: true
  validates :company, presence: true

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  delegate :regional_holidays, to: :office, allow_nil: true

  enum role: %i(trainee junior pleno senior)
end
