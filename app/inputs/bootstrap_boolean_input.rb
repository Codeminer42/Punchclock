class BootstrapBooleanInput < SimpleForm::Inputs::BooleanInput
  def input(wrapper_options)
    input_html_classes.delete 'form-control'
    super
  end
end
