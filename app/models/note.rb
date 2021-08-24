class Note < ApplicationRecord
  extend Enumerize

  belongs_to :user
  belongs_to :author, class_name: 'User'
  belongs_to :company

  validates_presence_of :title, :comment

  enumerize :rate, in: [:bad, :neutral, :good], scope: :shallow, default: :neutral
end
