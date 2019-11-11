# frozen_string_literal: true

class PunchesPaginationDecorator < Draper::CollectionDecorator
  include PunchesHelper

  delegate :reorder, :page, :current_page, :total_pages, :limit_value,
           :total_count, :num_pages, :to_key

  def initialize(params, object, options = {})
    @params = params
    @unpaginated_object = object
    @paginated_object = @unpaginated_object
                        .page(@params[:page])
                        .per(@params[:per])

    super(@paginated_object, options)
  end

  def total_hours
    secs_to_formated_hour(@unpaginated_object.total)
  end
end
