# frozen_string_literal: true

class ContributionsSpreadsheet < DefaultSpreadsheet
  def body(contribution)
    [
      contribution.users.map(&:name).join(', '),
      contribution.link,
      contribution.created_at.to_s,
      Contribution.human_attribute_name("state/#{contribution.state}"),
      contribution.pr_state,
      contribution.reviewed_by,
      contribution.reviewed_at.to_s,
      contribution.rejected_reason_text,
      contribution.updated_at.to_s
    ]
  end

  def header
    %w[
      authors
      link
      created_at
      state
      pr_state
      reviewed_by
      reviewed_at
      rejected_reason
      updated_at
    ].map { |attribute| Contribution.human_attribute_name(attribute) }
  end
end
