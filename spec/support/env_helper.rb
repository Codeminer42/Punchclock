# frozen_string_literal: true

module EnvHelper
  module_function

  def with_temp_env(vars)
    original_vars = ENV.select { |k, _| vars.key?(k) }
    cleanup_vars = vars.map { |k, _| [k, nil] }.to_h

    ENV.update(vars)

    yield

    ENV.update(cleanup_vars)
    ENV.update(original_vars)
  end
end
