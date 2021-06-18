# frozen_string_literal: true

class User::SessionsController < Devise::SessionsController
  def new
    super do |user|
      if user.valid_password?(user.password)
        user.errors.add(:email, :invalid_authentication)
        user.errors.add(:password, :invalid_authentication)
      end
    end
  end
end
