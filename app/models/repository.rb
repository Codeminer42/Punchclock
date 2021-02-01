class Repository < ApplicationRecord
  belongs_to :company
  has_many :contributions, dependent: :nullify

  validates :link, presence: true, uniqueness: { scope: :company_id, case_sensitive: false }
end
