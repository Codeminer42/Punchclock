class Punches::CalendarForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :days, :string
  attribute :project_id, :integer
  attribute :user_id, :integer
  attribute :from1, :string
  attribute :to1, :string
  attribute :from2, :string
  attribute :to2, :string

  validates_presence_of :days, :project_id, :from1, :from2, :to1, :to2
  validate :all_days_valid?


  def initialize(params={})
    super
    @punches = days.to_s.split(",").flat_map do |day|
      [
        Punch.new(from_time: from1, to_time: to1, project_id: project_id, when_day: day),
        Punch.new(from_time: from2, to_time: to2, project_id: project_id, when_day: day)
      ]
    end
  end

  # def model_name
  #   ActiveModel::Name.new("CalendarPunches")
  # end

  # def save
  #   return false unless valid?

  #   Punch.transaction do
  #     @punches.each(&:save!)
  #   end

  #   true
  # end

  def all_days_valid?

  end
end
