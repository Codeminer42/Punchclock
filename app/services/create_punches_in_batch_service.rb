class CreatePunchesInBatchService
  Result = Struct.new(:success, :errors) do
    def success?
      success
    end
  end

  def self.call(punches, company, additions, deletions)
    new(punches, company, additions, deletions).call
  end

  def initialize(punches, company, additions, deletions)
    @punches = punches
    @company = company
    @additions = additions
    @deletions = deletions
  end

  def call
    @punches.transaction do
      @punches.by_days(@deletions).delete_all if @deletions.any?
      @punches.where(company: @company).create!(@additions) if @additions
    end

    Result.new(true, [])
  rescue ActiveRecord::RecordInvalid => reason
    Result.new(false, reason.record.errors.full_messages)
  end
end