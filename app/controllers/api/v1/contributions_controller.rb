module Api
  module V1
    class ContributionsController < ActionController::API
      def latest
        contributions = Contribution.approved.order(id: :desc).first(25)
        render json: contributions, only: :link
      end
    end
  end
end
