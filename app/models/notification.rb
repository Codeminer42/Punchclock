class Notification < ActiveRecord::Base
  belongs_to :user
  validates :user_id, :message, presence: true

  def from
    from_user_id.nil? ? nil : User.find(from_user_id)
  end
end
