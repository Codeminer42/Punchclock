class Jwt::Auth
  def self.call(token:)
    new(token: token).call
  end

  def initialize(token:)
    @token = token
  end

  def call
    payload = Jwt::Decode.call(token: @token)
    return if expired?(payload)

    User.find_by_jwt_payload(payload)
  end

  private

  def expired?(payload)
    payload[:exp] < Time.now.to_i
  end
end
