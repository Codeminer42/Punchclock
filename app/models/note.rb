class Note < ApplicationRecord
  extend Enumerize

  belongs_to :user
  belongs_to :author, class_name: 'User'

  validates_presence_of :title, :comment

  enumerize :rate, in: %i[bad neutral good], scope: :shallow, default: :neutral

  scope :by_title_like, ->(title) { where("notes.title ILIKE ?", "%#{title}%") if title.present? }
  scope :by_user, ->(user_id) { where("notes.user_id = ?", user_id) if user_id.present? }
  scope :by_author, ->(author_id) { where("notes.author_id = ?", author_id) if author_id.present? }
  scope :by_rate, ->(rate) { where(rate:) if rate.present? }
end
