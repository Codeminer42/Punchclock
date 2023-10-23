# frozen_string_literal: true

class EducationExperiencePaginationDecorator < Draper::Decorator
  delegate_all

  def initialize(params, object, options = {})
    @params = params
    @unpaginated_object = object
    @paginated_object = @unpaginated_object
                        .page(@params[:page])
                        .per(@params[:per])

    super(@paginated_object, options)
  end

  def start_date
    I18n.l(model.start_date.to_date, format: :default)
  end

  def end_date
    if model.end_date.present?
      I18n.l(model.end_date.to_date, format: :default)
    else
      '-'
    end
  end

  def start_year
    model.start_date.to_date.year
  end

  def end_year
    if model.end_date.present?
      model.end_date.to_date.year
    else
      '-'
    end
  end
end
