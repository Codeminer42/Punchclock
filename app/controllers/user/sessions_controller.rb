# frozen_string_literal: true

class User::SessionsController < Devise::SessionsController
  include TwoFactorAuthentication

  before_action :authenticate_otp, only: [:create]

  def new
    super do |resource|
      if params[:commit].present?
        resource.valid?
        resource.errors.add(:password, "não pode ficar em branco") if params[:password].blank?
      end
    end
  end
end
