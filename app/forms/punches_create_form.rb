class PunchesCreateForm
  include ActiveModel::Model

  attr_accessor :punches

  validates :punches, presence: true
  validate :punches_validations, :punch_on_same_day_validation

  def initialize(punches: [], user: User.new)
    @punches = punches.map do |punch_params|
      Punch.new(**punch_params, user: user, company: user.company)
    end
  end

  def save
    return false unless valid?

    Punch.transaction do
      @punches.each(&:save!)
    end

    true
  end

  private

  def punches_validations
    @punches.each do |punch|
      errors.merge!(punch.errors) if punch.invalid?
    end
  end

  def punch_on_same_day_validation
    @punches.each do |punch|
      errors.add(:from, 'There is already a punch on the same day') if there_punch_on_the_same_day?(punch)
    end
  end

  def there_punch_on_the_same_day?(punch)
    punch.user.punches.by_days(punch.from).present?
  end
end
