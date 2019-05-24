# frozen_string_literal: true

ValidatesTimeliness.setup do |config|
  config.extend_orms = [:active_record]
end
