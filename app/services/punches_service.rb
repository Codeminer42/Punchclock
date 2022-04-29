class PunchesService
  def self.create(punches, user)
    punches_date_to_delete = punches.map { |punch| punch['from'] }

    create_delete_punches(punches, punches_date_to_delete, user)
  end

  private

  def self.create_delete_punches(punches, punches_date_to_delete, user)
    users_punches = user.punches

    users_punches.transaction do
      users_punches.by_days(punches_date_to_delete).delete_all
      users_punches.where(
        company: user.company
      ).create(punches)
    end
  end
end
