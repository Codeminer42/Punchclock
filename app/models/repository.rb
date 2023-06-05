class Repository < ApplicationRecord
  has_many :contributions, dependent: :nullify

  validates :link, presence: true, uniqueness: { case_sensitive: false }

  def to_s
    link
  end

  def name
    self.decorate.name
  end
end
