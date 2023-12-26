# frozen_string_literal: true

class AllocationsSpreadsheet < DefaultSpreadsheet
  def body(allocation)
    [
      allocation.user.name,
      allocation.user.email,
      allocation.project.name,
      allocation.user.mentor ? allocation.user.mentor.name : '-',
      allocation.user.mentor ? allocation.user.mentor.email : '-'
    ]
  end

  def header
    [
      User.human_attribute_name('name'),
      User.human_attribute_name('email'),
      I18n.t('allocation.project_name'),
      I18n.t('allocation.mentor_name'),
      I18n.t('allocation.mentor_email')
    ]
  end
end
