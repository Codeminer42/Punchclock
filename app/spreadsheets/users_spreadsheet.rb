# frozen_string_literal: true

class UsersSpreadsheet < DefaultSpreadsheet
  def body(user)
    [
      user.name,
      user.email,
      user.office&.city,
      user.roles_text,
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
      office
      roles
      specialty
      occupation
      contract_type
      github
      skills
    ].map { |attribute| User.human_attribute_name(attribute) }
  end
end
