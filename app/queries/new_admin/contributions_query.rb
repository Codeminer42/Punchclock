module NewAdmin
  class ContributionsQuery
    def initialize(filters)
      self.filters = filters
    end

    def self.call(*args)
      new(*args).call
    end

    def call
      contributions = scoped_contributions.order(created_at: :asc)
                                          .by_user(filters[:user_id])
                                          .by_state(filters[:state])
                                          .by_reviewed_at_from(filters[:by_reviewed_at_from])
                                          .by_reviewed_at_until(filters[:by_reviewed_at_until])
                                          .by_created_at_from(filters[:created_at_from])
                                          .by_created_at_until(filters[:created_at_until])
      contributions = contributions.this_week if filters[:this_week]
      contributions = contributions.last_week if filters[:last_week]

      contributions
    end

    private

    attr_accessor :filters

    def scoped_contributions
      Contribution.active_engineers
    end
  end
end
