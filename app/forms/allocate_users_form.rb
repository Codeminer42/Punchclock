class AllocateUsersForm
  include ActiveModel::Model

  attr_accessor :not_allocated_users, :project_id, :start_at, :end_at

  validates :project_id, presence: true
  validates_date :start_at
  validates_length_of :not_allocated_users, minimum: 1

  def save
    return unless valid?
    
    Allocation.create(user_id: not_allocated_users, project_id: project_id, start_at: start_at, end_at: end_at)
  end
end
