class Jwt::Verify
  class InvalidError < JWT::DecodeError; end
  def self.call(token)
    new(token).call
  end

  def initialize(token)
    @token = token[:token]
  end

  def call
    # toDo: define jti blacklist claim
    options = { verify_expiration: true, verify_jti: Jwt::Renew::ValidateJti }
    payload = JWT.decode(@token, ENV['JWT_SECRET_KEY'], options).first
    payload['sub']
  rescue JWT::DecodeError => e
    raise InvalidError.new(e.message)
  end
end
