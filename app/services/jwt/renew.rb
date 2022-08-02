class Jwt::Renew
  JTI_BLACKLIST = "jwt_jti_denied"
  #todo manage JTI blacklist with redis
  VALIDATE_JTI = ->(jti) { !Rails.cache.read("#{JTI_BLACKLIST}/#{jti}") }

  def initialize(token)
    @old_payload = JWT::decode(token, ENV['JWT_SECRET_TOKEN'], false).first
  end

  def generate!
    revoke!
    Jwt::Generate.new(user_id: @old_payload['sub'])
  end

  def revoke!
    jti, exp = @old_payload.values_at('jti', 'exp')
    #todo manage JTI blacklist with redis
    Rails.cache.write("#{JTI_BLACKLIST}/#{jti}", true)
  end
end
