# frozen_string_literal: true

class AdminsSpreadsheet < BaseSpreadsheet
  def body(user)
    [
      user.id,
      user.email,
      user.last_sign_in_at,
      user.last_sign_in_ip,
      user.name,
      user.hour_cost,
      user.confirmed_at,
      user.active,
      user.allow_overtime,
      user.occupation,
      user.observation,
      user.specialty,
      user.github,
      user.contract_type,
      user.role,
      I18n.l(user.created_at, format: :long),
      I18n.l(user.updated_at, format: :long)
    ]
  end

  def header
    %w[
      id
      email
      last_sign_in_at
      last_sign_in_ip
      name
      hour_cost
      confirmed_at
      active
      allow_overtime
      occupation
      observation
      specialty
      github
      contract_type
      role
      created_at
      updated_at
    ].map { |attribute| User.human_attribute_name(attribute) }
  end
end
