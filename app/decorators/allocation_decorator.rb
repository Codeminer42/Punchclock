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

  def project_name
    model.project ? model.project.name : nil
  end

  def user_level
    decorated_user(model).level
  end

  def user_specialty
    decorated_user(model).specialty
  end

  def user_english_level
    decorated_user(model).english_level
  end

  def user_skills
    decorated_user(model).skills
  end

  def allocation_end_at
    build_date(model.end_at)
  end

  private

  def decorated_user(allocation)
    UserDecorator.decorate(allocation.user)
  end

  def build_date(date)
    date ? date.to_time.strftime("%d/%m/%Y") : I18n.t('not_allocated')
  end
end
