# frozen_string_literal: true

class PunchesSpreadsheet < DefaultSpreadsheet
  def body(punch)
    [
      punch.user.name,
      punch.project.name,
      punch.when,
      punch.from,
      punch.to,
      punch.delta,
      I18n.t(punch.extra_hour),
      punch.comment
    ]
  end

  def header
    [
      User.human_attribute_name('name'),
      Punch.human_attribute_name('project'),
      Punch.human_attribute_name('when'),
      Punch.human_attribute_name('from'),
      Punch.human_attribute_name('to'),
      Punch.human_attribute_name('delta'),
      Punch.human_attribute_name('extra_hour'),
      Punch.human_attribute_name('comment')
    ]
  end
end
