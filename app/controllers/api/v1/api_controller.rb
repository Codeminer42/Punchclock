module Api
  module V1
    class ApiController < ActionController::API
      before_action :require_valid_jwt!

      private
      def require_valid_jwt!
        raise Jwt::Verify::InvalidError unless bearer_token.present?
        @current_user_id = Jwt::Verify.call(bearer_token)

      rescue Jwt::Verify::InvalidError => e
        Rails.logger.error("[JWT] ERROR: #{e.message}")
        render json: { error: :unauthorized }, status: :unauthorized
      end

      def bearer_token
        request.headers.fetch('Authorization', '')[/^Bearer (\S+)$/, 1]
      end

      def current_user
        return unless @current_user_id.present?
        @current_user ||= User.find(@current_user_id)
      end
    end
  end
end
