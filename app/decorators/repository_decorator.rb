class RepositoryDecorator < ApplicationDecorator
  delegate_all

  def languages
    language.split(',').first(3).to_sentence
  end
end
