module Api
  module V1
    class PunchesController < ApiController
      def index
        render json: scoped_punches, status: :ok, each_serializer: PunchSerializer
      end

      def bulk
        form = PunchesCreateForm.new(bulk_punches_params)
        if form.save
          render json: form.punches, status: :created, each_serializer: PunchSerializer
        else
          render json: form.errors, status: :unprocessable_entity
        end
      end

      private

      def scoped_punches
        current_user.punches
      end

      def bulk_punches_params
        {
          user: current_user,
          punches: params.permit(punches: %i[from to project_id])[:punches]
        }
      end
    end
  end
end
