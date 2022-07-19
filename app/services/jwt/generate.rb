class Jwt::Generate
  def initialize(expire_at: 1.week.from_now, user_id:, last_jti: nil)
    @payload = {
      exp: expire_at.to_i,
      sub: user_id,
      env: Rails.env
      jti: generate_next_jti(last_jti)
    }
  end

  def token
    JWT.encode(@payload, ENV['JWT_SECRET_KEY'])
  end

  alias_method :to_s, :token

  private
  def generate_next_jti(last_jti)
    # toDo: define jti blacklist claim
    SecureRandom.uuid
  end
end
