# frozen_string_literal: true

class AdminsSpreadsheet < DefaultSpreadsheet
  def body(user)
    [
      user.id,
      user.email,
      translate_date(user.last_sign_in_at),
      user.last_sign_in_ip,
      user.name,
      translate_date(user.confirmed_at),
      user.active,
      user.allow_overtime,
      user.occupation,
      user.observation,
      user.specialty,
      user.github,
      user.contract_type,
      user.roles_text,
      translate_date(user.started_at),
      translate_date(user.created_at),
      translate_date(user.updated_at)
    ]
  end

  def header
    %w[
      id
      email
      last_sign_in_at
      last_sign_in_ip
      name
      confirmed_at
      active
      allow_overtime
      occupation
      observation
      specialty
      github
      contract_type
      roles
      started_at
      created_at
      updated_at
    ].map { |attribute| User.human_attribute_name(attribute) }
  end
end
