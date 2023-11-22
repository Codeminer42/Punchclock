class NoteDecorator < Draper::Decorator
  delegate_all
  decorates_association :questionnaire

  def self.collection_decorator_class
    PaginatingDecorator
  end
end