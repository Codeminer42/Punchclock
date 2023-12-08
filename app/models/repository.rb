class Repository < ApplicationRecord
  has_many :contributions, dependent: :nullify

  validates :link, presence: true, uniqueness: { case_sensitive: false }

  def to_s
    link
  end

  scope :with_distinct_languages, -> { group(:language).select(:language).where.not(language: [nil, '']) }
  scope :by_repository_name_like, ->(repository_name) {
    if repository_name.present?
      where("link ILIKE ?", "%#{repository_name}%")
    end
  }
  scope :by_languages, ->(languages) { where(language: languages) if languages.present? }

  def self.ransackable_attributes(auth_object = nil)
    %w[created_at description highlight id issues language link stars updated_at]
  end
end
