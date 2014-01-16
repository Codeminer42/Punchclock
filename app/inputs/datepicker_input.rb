class DatepickerInput < SimpleForm::Inputs::Base

  def datepicker_input_html_options
    value = object.send(attribute_name)
    if value.present? && value.kind_of?(Date)
      input_html_options.merge(:value => I18n.l(value))
    else
      input_html_options
    end
  end

  def input
    @builder.text_field(attribute_name, datepicker_input_html_options)
  end
end
