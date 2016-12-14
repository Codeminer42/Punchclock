class Evaluation < ActiveRecord::Base
  belongs_to :user
  belongs_to :reviewer, class_name: :User

  validates :user, presence: true
  validates :review, presence: true
end
