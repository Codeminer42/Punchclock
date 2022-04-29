module Api
  module V1
    class PunchesController < ApiController
      def create
        new_punches = params[:_json]
        return render json: { message: 'There are no punches to create' }, status: :unprocessable_entity if new_punches.nil? || new_punches.empty?

        permitted_punches = params.permit(_json: [:from, :to, :project_id]).require(:_json)

        created_punches = PunchesService.create(permitted_punches, current_user)

        render json: created_punches, status: :created
      end
    end
  end
end
