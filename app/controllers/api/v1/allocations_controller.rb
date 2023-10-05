module Api
  module V1
    class AllocationsController < ActionController::API
      before_action :authenticate_user!

      def current
        render json: { currentAllocation: { id: current_user.current_allocation&.id } }
      end
    end
  end
end
