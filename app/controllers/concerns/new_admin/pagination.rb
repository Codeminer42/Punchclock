# frozen_string_literal: true

module NewAdmin
  module Pagination
    extend ActiveSupport::Concern

    included do
      def paginate_record(record, decorate: true)
        paginated_result = record.page(params[:page]).per(params[:per])
        return paginated_result.decorate if decorate

        paginated_result
      end
    end
  end
end
