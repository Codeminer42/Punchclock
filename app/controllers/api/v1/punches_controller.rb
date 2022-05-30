module Api
  module V1
    class PunchesController < ApiController
      def index
        render json: scoped_punches, status: :ok, each_serializer: PunchSerializer
      end

      def bulk
        created_punches = BulkPunchesService.call(bulk_punches_params, current_user)
        render json: created_punches, status: :created, each_serializer: PunchSerializer
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      private

      def scoped_punches
        current_user.punches
      end

      def bulk_punches_params
        params.permit(punches: [:from, :to, :project_id]).require(:punches)
      end
    end
  end
end
