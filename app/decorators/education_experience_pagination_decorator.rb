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
end
