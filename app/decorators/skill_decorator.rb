class SkillDecorator < Draper::Decorator
  delegate_all
  decorates_association :skill

  def self.collection_decorator_class
    PaginatingDecorator
  end
end
