# frozen_string_literal: true

class ContributionsSpreadsheet < DefaultSpreadsheet
  def body(contribution)
    [
      contribution.user.name,
      contribution.link,
      Contribution.human_attribute_name("state/#{contribution.state}"),
      contribution.pr_state,
      translate_date(contribution.created_at),
      translate_date(contribution.updated_at)
    ]
  end

  def header
    %w[
      user
      link
      state
      pr_state
      created_at
      updated_at
    ].map { |attribute| Contribution.human_attribute_name(attribute) }
  end
end
