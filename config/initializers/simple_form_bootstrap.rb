SimpleForm.setup do |config|
  config.input_class = 'form-control'

  config.wrappers(:bootstrap,
                  tag: 'div',
                  class: 'form-group',
                  error_class: 'error') do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.use :input
    b.use :error, wrap_with: { tag: 'span', class: 'help-inline' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  end

  config.wrappers(:group,
                  tag: 'div',
                  class: 'form-group',
                  error_class: 'error') do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.use :input, wrap_with: { class: 'input-group' }
    b.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
    b.use :error, wrap_with: { tag: 'span', class: 'help-inline' }
  end

  config.wrappers(:btn_group,
                  tag: 'div',
                  class: 'form-group',
                  error_class: 'error') do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.use :input, wrap_with: { class: 'input-group' }
    b.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
    b.use :error, wrap_with: { tag: 'span', class: 'help-inline' }
  end

  config.wrappers(:checkbox,
                  tag: :div,
                  class: 'checkbox',
                  error_class: 'has-error') do |b|

    b.use :html5

    b.wrapper tag: :label do |ba|
      ba.use :input
      ba.use :label_text
    end

    b.use :hint,  wrap_with: { tag: :p, class: 'help-block' }
    b.use :error, wrap_with: { tag: :span, class: 'help-block text-danger' }
  end
  config.default_wrapper = :bootstrap
end
