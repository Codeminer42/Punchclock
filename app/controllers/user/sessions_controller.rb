# frozen_string_literal: true

class User::SessionsController < Devise::SessionsController
  def new
    super do |resource|
      if params[:commit].present?
        resource.errors.add(:email, :invalid_authentication)
        resource.errors.add(:password, :invalid_authentication)
      end
    end
  end
end
