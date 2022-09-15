class CreatePunchesInBatchService
  Result = Struct.new(:success, :errors) do
    def success?
      success
    end
  end

  def self.call(punches, additions, deletions)
    new(punches, additions, deletions).call
  end

  def initialize(punches, additions, deletions)
    @punches = punches
    @additions = additions
    @deletions = deletions
  end

  def call
    error_message = I18n.t('activerecord.errors.models.period.attributes.base.invalid_periods')

    return Result.new(false, [error_message]) if !@additions.empty? && invalid_day_periods?

    @punches.transaction do
      @punches.by_days(@deletions).delete_all if @deletions.any?
      @punches.create!(@additions) if @additions
    end

    Result.new(true, [])
  rescue ActiveRecord::RecordInvalid => reason
    Result.new(false, reason.record.errors.full_messages)
  end

  private

  def invalid_day_periods?
    morning, lunch = @additions.map do |p|
      p.slice(:from, :to).transform_values { |v| DateTime.parse(v) }
    end

    expected_order = [morning[:from], morning[:to], lunch[:from], lunch[:to]]
    expected_order != expected_order.uniq.sort
  end
end
