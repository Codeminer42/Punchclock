class Repository < ApplicationRecord
  has_many :contributions, dependent: :nullify

  validates :link, presence: true, uniqueness: { case_sensitive: false }

  def to_s
    link
  end

  scope :languages, -> { select(:language).distinct.where.not(language: [nil, '']) }
  scope :by_repository_name_like, lambda { |repository_name|
    if repository_name.present?
      where("link ILIKE ?", "%#{repository_name}%")
        .or(where("link ILIKE ?", "%#{repository_name}"))
    end
  }
  scope :by_languages, ->(languages) { where(language: languages) if languages.present? }
end
