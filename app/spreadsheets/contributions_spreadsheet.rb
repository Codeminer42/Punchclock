# frozen_string_literal: true

class ContributionsSpreadsheet < DefaultSpreadsheet
  def body(contribution)
    [
      contribution.user.name,
      contribution.link,
      Contribution.human_attribute_name("state/#{contribution.state}"),
      contribution.pr_state,
      contribution.created_at,
      contribution.updated_at
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
