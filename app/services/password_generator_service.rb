require 'passgen'

class PasswordGeneratorService
  def self.call()
    min_length = Devise.password_length.first
    Passgen::generate(length: min_length)
  end
end
