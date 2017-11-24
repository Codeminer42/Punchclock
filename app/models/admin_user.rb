class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :company
  validates :email, :company_id, presence: true

  scope :not_super, -> { where(is_super: [nil, false]) }

  def to_s
    email
  end
end
