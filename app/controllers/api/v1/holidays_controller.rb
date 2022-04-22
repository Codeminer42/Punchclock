module Api
  module V1
    class HolidaysController < ActionController::API
      before_action :authenticate_user!

      def holidays_dashboard
        render json: current_user.office_holidays
      end
    end
  end
end
