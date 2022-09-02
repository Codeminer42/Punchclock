# frozen_string_literal: true

class Roles
  NORMAL = 'normal'
  EVALUATOR = 'evaluator'
  ADMIN = 'admin'
  SUPER_ADMIN = 'super_admin'
  OPEN_SOURCE_MANAGER = 'open_source_manager'
  HR = 'hr'

  def self.all
    [NORMAL, EVALUATOR, ADMIN, SUPER_ADMIN, OPEN_SOURCE_MANAGER, HR]
  end
end
