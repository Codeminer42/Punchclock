class BulkPunchesService
  class << self
    def call(collection_of_punches, user)
      insert_days = collection_of_punches.map { |punch| punch['from'] }
      raise 'There is already a punch on the same day' if there_punch_on_the_same_day?(user, insert_days)

      create_new_punch(user, collection_of_punches)
    end

    private

    def there_punch_on_the_same_day?(user, insert_days)
      user.punches.by_days(insert_days).present?
    end

    def create_new_punch(user, collection_of_punches)
      user.punches.where(
        company: user.company
      ).create(collection_of_punches)
    end
  end
end
