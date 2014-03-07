class PunchesDecorator < Draper::CollectionDecorator
  delegate :reorder, :page, :current_page, :total_pages, :limit_value,
           :total_count, :num_pages, :to_key
  def total_hours
    h.secs_to_formated_hour(object.total)
  end
end
