# frozen_string_literal: true

class ControllerTestClassForPagination
  include NewAdmin::Pagination

  def params
    {
      page: 1,
      per: 25
    }
  end
end
