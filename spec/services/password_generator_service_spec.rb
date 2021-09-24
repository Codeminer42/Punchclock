require 'rails_helper'

RSpec.describe PasswordGeneratorService do
  it 'create a random password with devise minimum password length' do
    password = PasswordGeneratorService.call
    expect(password.length).to be(Devise.password_length.first)
  end
end
