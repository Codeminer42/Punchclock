class Evaluation < ActiveRecord::Base
  KINDS = { written: 'written', received: 'received' }

  belongs_to :user
  belongs_to :reviewer, class_name: :User

  validates :user, presence: true
  validates :review, presence: true

  def self.written?(evaluation_kind)
    evaluation_kind == KINDS[:written]
  end

  def self.received?(evaluation_kind)
    evaluation_kind == KINDS[:received]
  end
end
