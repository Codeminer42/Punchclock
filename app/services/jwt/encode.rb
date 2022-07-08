class Jwt::Encode
  def self.call(exp: 1.week.from_now, user:)
    new(exp: exp, user: user).call
  end

  def initialize(exp:, user:)
    user.regenerate_auth_token
    @exp, @payload, @auth_token = exp, user.jwt_payload, user.auth_token
  end

  def call
    JWT.encode(@payload.merge(exp: @exp.to_i), @auth_token)
  end
end
