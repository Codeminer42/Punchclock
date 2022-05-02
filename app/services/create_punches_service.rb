class CreatePunchesService
  class << self
    def call(collection_of_punches, user)
      days_to_delete = collection_of_punches.map { |punch| punch['from'] }

      ActiveRecord::Base.transaction do
        delete_punches_for_the_same_day(user, days_to_delete)
        create_new_punch(user, collection_of_punches)
      end
    end

    private

    def delete_punches_for_the_same_day(user, days_to_delete)
      user.punches.by_days(days_to_delete).delete_all
    end

    def create_new_punch(user, collection_of_punches)
      user.punches.where(
        company: user.company
      ).create(collection_of_punches)
    end
  end
end
