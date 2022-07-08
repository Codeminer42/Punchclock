module JwtAuthable
  extend ActiveSupport::Concern

  def auth!
    @current_user = Jwt::Auth.(token: token)

    render json: { error: :unauthorized }, status: :unauthorized unless @current_user
  end

  def deny!
    @current_user = Jwt::Deny.(token: token)
    # check for wrong signature
    render json: { message: :signed_out }, status: :ok
  end

  def token
    request.headers['Authorization'].match(/Bearer ([\w-]*\.[\w-]*\.[\w-]*)/)[1]
  end

  def current_user
    @current_user
  end
end
