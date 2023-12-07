module NewAdmin
  class SkillsQuery
    def initialize(filters)
      self.filters = filters
    end

    def self.call(*args)
      new(*args).call
    end

    def call
      Skill.order(title: :asc).by_title_like(filters[:title])
    end

    private

    attr_accessor :filters
  end
end
