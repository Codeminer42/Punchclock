class Jwt::Renew
  def initialize(token)
    @old_payload = JWT::decode(@token, ENV['JWT_SECRET_TOKEN'], false).first
  end

  def generate!
    revoke!
    Jwt::Generate.new(@old_payload.except(:jti, :exp))
  end

  def revoke!
    jti, exp = payload.values_at(:jti, :exp)
    Rails.cache.write("jwt_jti_denied/#{jti}", expires_in: exp) { true }
  end

  class ValidateJti
    self.call(jti)
      !Rails.cache.read("jwt_jti_denied/#{jti}")
    end
  end
end
