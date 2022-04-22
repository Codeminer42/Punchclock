module Api
  module V1
    class ApiController < ActionController::API
      before_action :auth

      def current_user
        @current_user ||= User.find_by(token: token)
      end

      private

      def auth
        return render json: { message: 'Missing Token' }, status: :unauthorized if token.nil?
        return render json: { message: 'Invalid Token' }, status: :unauthorized unless User.exists?(token: token)
      end

      def token
        @token ||= request.headers[:token]
      end
    end
  end
end
