class Jwt::Verify
  class InvalidError < JWT::DecodeError; end
  def self.call(token)
    new(token: token).call
  end

  def initialize(token:, secret: ENV['JWT_SECRET_KEY'])
    @secret = secret
    @token = token
  end

  def call
    options = { verify_expiration: !Rails.env.development?, 
                verify_jti: Jwt::Renew::VALIDATE_JTI }
    payload = JWT.decode(@token, @secret, true, options).first
    raise InvalidError.new('Invalid token for this Rails.env') unless payload['env'] == Rails.env

    payload['sub']
  rescue JWT::DecodeError => e
    raise InvalidError.new(e.message)
  end
end
