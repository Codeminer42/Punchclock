# frozen_string_literal: true

class UsersSpreadsheet < BaseSpreadsheet
  def body(user)
    [
      user.name,
      user.email,
      user.level_text,
      user.office&.city,
      user.role_text,
      user.specialty_text,
      user.occupation_text,
      user.contract_type_text,
      user.github,
      user.skills
    ]
  end

  def header
    %w[
      name
      email
      level
      office
      role
      specialty
      occupation
      contract_type
      github
      skills
    ].map { |attribute| User.human_attribute_name(attribute) }
  end
end
