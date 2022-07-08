class Jwt::Deny
  def self.call(token:)
    new(token: token).call
  end

  def initialize(token:)
    @token = token
  end

  def call
    payload = Jwt::Decode.call(token: @token)
    User.find_by_jwt_payload(payload)
        .update! auth_token: nil
  end
end
