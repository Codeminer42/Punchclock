class AllocateUsersForm
  include ActiveModel::Model

  attr_accessor :not_allocated_users, :company_id, :project_id, :start_at, :end_at

  validates :project_id, :company_id, presence: true
  validates_date :start_at
  validates_length_of :not_allocated_users, minimum: 2

  def save
    return unless valid?

    ActiveRecord::Base.transaction do
      not_allocated_users.each do |user_id|
        next if user_id.blank?

        Allocation.create(user_id: user_id, company_id: company_id, project_id: project_id, start_at: start_at, end_at: end_at)
      end
    end
  end
end
