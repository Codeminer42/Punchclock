class RepositoryDecorator < ApplicationDecorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end
  
  def languages
    return '' unless language

    language.split(',').first(3).to_sentence
  end
end
