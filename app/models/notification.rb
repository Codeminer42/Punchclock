class Notification < ActiveRecord::Base
  belongs_to :user
  validates :user_id, :message, presence: true
  before_create :record_default_event_path

  def from
    from_user_id.nil? ? nil : User.find(from_user_id)
  end

private
  def record_default_event_path
    self.event_path = '#' if self.event_path.nil?
  end
end
