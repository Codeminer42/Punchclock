module Api
  module V1
    class PunchesController < ApiController
      def create
        new_punches = params[:punches]
        return render json: { message: 'There are no punches to create' }, status: :bad_request if new_punches.nil? || new_punches.values.empty?

        deletes = new_punches.keys

        @punches = current_user.punches
        @punches.transaction do
          @punches.by_days(deletes).delete_all
          @punches.where(
            company: current_user.company
          ).create(new_punches.values)
        end

        created_punches = @punches.where(
          company: current_user.company,
          project_id: new_punches.values.flatten.map{|p| p[:project_id] },
          from: new_punches.values.flatten.map{|p| p[:from] },
          to: new_punches.values.flatten.map{|p| p[:to] }
        )

        render json: created_punches, status: :created
      end
    end
  end
end
