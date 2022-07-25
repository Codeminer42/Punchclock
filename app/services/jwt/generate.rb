class Jwt::Generate
  attr_reader :payload

  def initialize(expire_at: 1.week.from_now, user_id:, secret: ENV['JWT_SECRET_KEY'])
    @secret = secret
    @payload = {
      exp: expire_at.to_i,
      sub: user_id,
      env: Rails.env,
      jti: SecureRandom.uuid
    }
  end

  def token
    JWT.encode(@payload, @secret)
  end

  alias_method :to_s, :token

  def to_json(options = { options: '' })
    to_h.to_json(options)
  end

  def to_h
    { access_token: to_s }
  end
end
