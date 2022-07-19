module Api
  module V1
    class ApiController < ActionController::API
      before_action :require_valid_jwt!

      private
      def require_valid_jwt!
        @current_user_id = Jwt::Verify.call(token: bearer_token)

        rescue Jwt::Verify::InvalidError
          render json: { error: :unauthorized }, status: :unauthorized
      end

      def bearer_token
        request.headers['Authorization'].match(/^Bearer (\S+)$/)[1]
      end

      def current_user
        @current_user = User.find(@current_user_id)
      end
    end
  end
end
