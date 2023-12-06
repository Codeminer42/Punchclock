module NewAdmin
  class ContributionsQuery
    def initialize(filters)
      self.filters = filters
    end

    def self.call(*args)
      new(*args).call
    end

    def call
      scoped_contributions.order(created_at: :asc)
                          .by_user(filters[:user_id])
                          .by_state(filters[:state])
                          .by_reviewed_at_from(filters[:by_reviewed_at_from])
                          .by_reviewed_at_until(filters[:by_reviewed_at_until])
                          .by_created_at_from(filters[:created_at_from])
                          .by_created_at_until(filters[:created_at_until])
    end

    private

    attr_accessor :filters

    def scoped_contributions
      Contribution.active_engineers
    end
  end
end
