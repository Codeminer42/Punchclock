ActionView::Base.field_error_proc = proc do |html_tag|
  class_attr_index = html_tag.index 'class="'
  class_value_index = 7

  if class_attr_index.present?
    html_tag.insert class_attr_index + class_value_index, 'is-invalid '
  else
    html_tag.insert html_tag.index('>'), ' class="is-invalid"'
  end
end
