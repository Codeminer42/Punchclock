module Api
  module V1
    class CompaniesController < ApiController
      def users
        render json: company.users.active.engineer.as_json(only: %i[email name github office_id])
      end

      def offices
        render json: company.offices
      end

      private

      def company
        @company ||= current_user.company
      end
    end
  end
end
