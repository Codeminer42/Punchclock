module Api
  module V1
    class AuthController < ApiController
      include JwtAuthable

      # POST /api/v1/auth
      def create
        @user = User.find_by(user_params.slice(:email))

        if @user.valid_password?(user_params[:password])
          response.headers['Authorization'] = "Bearer #{Jwt::Encode.(user: @user)}"
          render json: @user, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      # UPDATE /api/v1/auth
      def deny_auth_token
        deny!
      end

      private
      def user_params
        params.permit(:email, :password)
      end
    end
  end
end
