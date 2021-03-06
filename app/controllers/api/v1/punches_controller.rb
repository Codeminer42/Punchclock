module Api
  module V1
    class PunchesController < ApiController
      def index
        render json: scoped_punches, status: :ok, each_serializer: PunchSerializer
      end

      def show
        render json: scoped_punch, status: :found, each_serializer: PunchSerializer
      end

      def bulk
        form = PunchesCreateForm.new(current_user, bulk_punches_params)
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

      def scoped_punch
        scoped_punches.find(params[:id])
      end

      def bulk_punches_params
        params.permit(punches: %i[from to project_id])[:punches]
      end
    end
  end
end
