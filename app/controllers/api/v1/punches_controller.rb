module Api
  module V1
    class PunchesController < ApiController
      def index
        render json: scoped_punches, status: :ok, each_serializer: PunchSerializer
      end

      def show
        render json: scoped_punch, status: :found, each_serializer: PunchSerializer
      end

      private

      def scoped_punches
        current_user.punches
      end

      def scoped_punch
        scoped_punches.find(params[:id])
      end
    end
  end
end
