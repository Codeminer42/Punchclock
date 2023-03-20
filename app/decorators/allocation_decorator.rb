# frozen_string_literal: true

class AllocationDecorator < Draper::Decorator
  delegate_all

  def hourly_rate
    h.humanized_money_with_symbol(super)
  end

  def to_s
    "##{model.id}"
  end

  def user_name
    model.user.first_and_last_name
  end

  def user_level
    model.user.decorate.level
  end

  def user_specialty
    model.user.decorate.specialty
  end

  def user_english_level
    model.user.decorate.english_level
  end

  def user_skills
    model.user.decorate.skills
  end

  def end_at
    build_date(model.end_at)
  end

  private

  def build_date(date)
    date ? I18n.l(date) : I18n.t('not_allocated')
  end
end
