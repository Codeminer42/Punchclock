class RepositoryDecorator < ApplicationDecorator
  delegate_all

  def languages
    return '' unless language

    language.split(',').first(3).to_sentence
  end
end
