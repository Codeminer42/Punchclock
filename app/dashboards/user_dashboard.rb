require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    active: Field::Boolean,
    allocations: Field::HasMany,
    allow_overtime: Field::Boolean,
    authored_notes: Field::HasMany,
    company: Field::BelongsTo,
    confirmation_sent_at: Field::DateTime,
    confirmation_token: Field::String,
    confirmed_at: Field::DateTime,
    consumed_timestep: Field::Number,
    contract_company_country: Field::Number,
    contract_type: Field::Number,
    contributions: Field::HasMany,
    current_sign_in_at: Field::DateTime,
    current_sign_in_ip: Field::String,
    email: Field::String,
    encrypted_otp_secret: Field::String,
    encrypted_otp_secret_iv: Field::String,
    encrypted_otp_secret_salt: Field::String,
    encrypted_password: Field::String,
    evaluations: Field::HasMany,
    github: Field::String,
    last_sign_in_at: Field::DateTime,
    last_sign_in_ip: Field::String,
    level: Field::Number,
    managed_offices: Field::HasMany,
    name: Field::String,
    notes: Field::HasMany,
    observation: Field::Text,
    occupation: Field::Text,
    office: Field::BelongsTo,
    otp_backup_codes: Field::String,
    otp_required_for_login: Field::Boolean,
    otp_secret: Field::String,
    projects: Field::HasMany,
    punches: Field::HasMany,
    remember_created_at: Field::DateTime,
    reset_password_sent_at: Field::DateTime,
    reset_password_token: Field::String,
    reviewer: Field::BelongsTo,
    role: Field::Number,
    roles: Field::HasMany,
    sign_in_count: Field::Number,
    skills: Field::HasMany,
    specialty: Field::String,
    started_at: Field::Date,
    token: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    name
    email
    office
    roles
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    name
    email
    occupation
    office
    roles
    skills
    specialty
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    allocations
    allow_overtime
    company
    contract_company_country
    contract_type
    email
    github
    level
    managed_offices
    name
    observation
    occupation
    office
    projects
    reviewer
    roles
    skills
    specialty
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(user)
  #   "User ##{user.id}"
  # end
end
