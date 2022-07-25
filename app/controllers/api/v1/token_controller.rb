module Api
  module V1
    class TokenController < ApiController
      skip_before_action :require_valid_jwt!, only: :request_token

      # POST /api/v1/token/request
      def request_token
        @user = User.find_by(email: params[:email])

        if @user && @user.valid_password?(params[:password])
          render json: Jwt::Generate.new(user_id: @user.id), status: :created
        else
          render json: { error: I18n.t('errors.messages.wrong_credentials') }, status: :unprocessable_entity
        end
      end

      # POST /api/v1/token/refresh
      def refresh_token
        render json: Jwt::Renew.new(bearer_token).generate!, status: :created
      end
    end
  end
end
