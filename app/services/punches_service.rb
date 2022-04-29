class PunchesService
  def self.create(punches, user)
    deletes = punches.map { |punch| punch['from'] }

    @punches = user.punches
    created_punches = @punches.transaction do
      @punches.by_days(deletes).delete_all
      @punches.where(
        company: user.company
      ).create(punches)
    end

    return created_punches
  end
end
