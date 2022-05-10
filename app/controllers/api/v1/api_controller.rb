module Api
  module V1
    class ApiController < ActionController::API
      before_action :auth

      def current_user
        @current_user ||= if doorkeeper_token
                            User.find(doorkeeper_token.resource_owner_id)
                          else
                            User.find_by(token: token)
                          end
      end

      private

      def auth
        unless token || request.headers[:authorization]
          return render json: { message: 'Missing Token' },
                        status: :unauthorized
        end

        unless (valid_doorkeeper_token? && User.active.exists?(doorkeeper_token.resource_owner_id)) ||
               (token && User.exists?(token: token))
          render json: { message: 'Invalid Token' },
                 status: :unauthorized

        end
      end

      def token
        @token ||= request.headers[:token]
      end
    end
  end
end
