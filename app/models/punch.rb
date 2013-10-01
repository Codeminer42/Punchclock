class Punch < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  belongs_to :company
  has_many :comments
  validates :from, :to, :project_id, :user_id, :company_id, presence: true
  validate :check_time

  def delta
    (self.to - self.from) / 3600
  end

private
  def check_time
    if self.from.present? && self.to.present?
      if self.to < self.from
        errors.add(:from, "can't be greater than From time")
      end

      if self.from.to_date != self.to.to_date
        errors.add(:to, "can't be in diferent dates")
      end
    end
  end
end
