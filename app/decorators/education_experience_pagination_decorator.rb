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
    model.start_date.to_date.to_fs(:date)
  end

  def end_date
    model.end_date.to_date.to_fs(:date)
  end

  def start_year
    model.start_date.to_date.year
  end

  def end_year
    model.end_date.to_date.year
  end
end
