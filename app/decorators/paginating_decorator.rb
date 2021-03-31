class PaginatingDecorator < Draper::CollectionDecorator
  delegate :current_page, 
    :total_entries, 
    :total_pages, 
    :per_page, 
    :offset, 
    :limit_value,
    :total_count, 
    :num_pages
end