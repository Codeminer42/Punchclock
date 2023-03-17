# frozen_string_literal: true

class AllocationChartDecorator < Draper::Decorator
  delegate_all

  def name
    model.user.first_and_last_name
  end

  def project_name
    model.project ? model.project.name : nil
  end

  def level
    decorated_user(model).level
  end

  def specialty
    decorated_user(model).specialty
  end

  def english_level
    decorated_user(model).english_level
  end

  def skills
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
