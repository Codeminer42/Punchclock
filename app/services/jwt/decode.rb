class Jwt::Decode
  def self.call(token)
    new(token).call
  end

  def initialize(token)
    @token = token
  end

  def call
    jwt_payload = JSON.parse Base64.decode64 @token[:token].split('.')[1]
    user_auth_token = User.find(jwt_payload['id']).auth_token

    decoded = JWT.decode(@token[:token], user_auth_token)
    HashWithIndifferentAccess.new decoded[0]
  end
end
