# frozen_string_literal: true

class RepositoriesSpreadsheet < BaseSpreadsheet
  def body(repository)
    [
      repository.link,
      translate_date(repository.created_at),
      translate_date(repository.updated_at)
    ]
  end

  def header
    %w[
      link
      created_at
      updated_at
    ].map { |attribute| Repository.human_attribute_name(attribute) }
  end
end
