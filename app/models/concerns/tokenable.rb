module Tokenable
  extend ActiveSupport::Concern

  def generate_token
    self.token = generate_unique_secure_token
  end

  def destroy_token
    self.token = nil
  end

  private
        
  def generate_unique_secure_token
    token = SecureRandom.base58(32)
    token = generate_unique_secure_token if self.class.exists?(token: token)
    token
  end
end
