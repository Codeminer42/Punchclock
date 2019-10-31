# frozen_string_literal: true

class AdminsSpreadsheet < BaseSpreadsheet
  def body(user)
    [
      user.id,
      user.email,
      user.current_sign_in_at,
      user.last_sign_in_at,
      user.current_sign_in_ip,
      user.last_sign_in_ip,
      user.created_at,
      user.updated_at,
      user.name,
      user.reset_password_token,
      user.reset_password_sent_at,
      user.remember_created_at,
      user.hour_cost,
      user.confirmation_token,
      user.confirmed_at,
      user.confirmation_sent_at,
      user.active,
      user.allow_overtime,
      user.occupation,
      user.observation,
      user.specialty,
      user.github,
      user.contract_type,
      user.role
    ]
  end

  def header
    %w[
      id
      email
      current_sign_in_at
      last_sign_in_at
      current_sign_in_ip
      last_sign_in_ip
      created_at
      updated_at
      name
      reset_password_token
      reset_password_sent_at
      reset_password_sent_at
      remember_created_at
      hour_cost
      confirmation_token
      confirmed_at
      confirmation_sent_at
      active
      allow_overtime
      occupation
      observation
      specialty
      github
      contract_type
      role
    ].map { |attribute| User.human_attribute_name(attribute) }
  end
end
