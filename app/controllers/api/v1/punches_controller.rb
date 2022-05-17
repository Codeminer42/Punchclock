module Api
  module V1
    class PunchesController < ApiController
      def index
        render json: scoped_punches, status: :ok, each_serializer: PunchSerializer
      end

      private

      def scoped_punches
        current_user.punches
      end
    end
  end
end
