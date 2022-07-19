module Api
  module V1
    class TokenController < ApiController
      skip_before_action :require_valid_jwt!, only: :create

      # POST /api/v1/token/request
      def request
        @user = User.find_for_databse_authentication(email: user_params[:email]))

        if @user && @user.valid_password?(user_params[:password])
          @token = Jwt::Generate.new(user_id: @user['id'])
          render json: token_as_json, status: :created
        else
          render json: { error: "Usuário ou Senha incorretos" }, status: :unprocessable_entity
        end
      end

      # POST /api/v1/token/refresh
      def refresh
        @token = Jwt::Renew(bearer_token).generate!
        render json: token_as_json, status: :created
      end

      # UPDATE /api/v1/token/revoke
      def revoke
        deny!
      end

      private

      def token_as_json
        { access_token: @token.to_s }
      end

      def bearer_token
        request.headers['Authorization'].match(/^Bearer (\S+)$/)[1]
      end

      def user_params
        params.permit(:email, :password)
      end
    end
  end
end
