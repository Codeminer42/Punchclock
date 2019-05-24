# frozen_string_literal: true

class OfficeDecorator < Draper::Decorator
  delegate_all

  def score
    model.score || I18n.t('office.user_not_evaluated')
  end
end
