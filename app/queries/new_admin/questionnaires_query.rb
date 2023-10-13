module NewAdmin
  class QuestionnairesQuery
    def initialize(filters)
      self.filters = filters
    end

    def self.call(*args)
      new(*args).call
    end

    def call
      retrieve_questionnaires
    end

    private

    attr_accessor :filters

    def retrieve_questionnaires
      Questionnaire.order(title: :asc)
                   .by_title_like(filters[:title])
                   .by_active(filters[:active])
                   .by_kind(filters[:kind])
                   .by_created_at_from(filters[:created_at_from])
                   .by_created_at_until(filters[:created_at_until])
    end
  end
end
