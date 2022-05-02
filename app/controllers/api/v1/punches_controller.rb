module Api
  module V1
    class PunchesController < ApiController
      def create
        created_punches = CreatePunchesService.call(create_punches_params, current_user)
        render json: created_punches, status: :created
      end

      private

      def create_punches_params
        params.permit(punches: [:from, :to, :project_id]).require(:punches)
      end
    end
  end
end
