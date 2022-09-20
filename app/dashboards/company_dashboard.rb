require "administrate/base_dashboard"

class CompanyDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    allocations: Field::HasMany,
    avatar: Field::String,
    contributions: Field::HasMany,
    end_period: Field::Number,
    evaluations: Field::HasMany,
    name: Field::String,
    offices: Field::HasMany,
    projects: Field::HasMany,
    punches: Field::HasMany,
    questionnaires: Field::HasMany,
    regional_holidays: Field::HasMany,
    repositories: Field::HasMany,
    skills: Field::HasMany,
    users: Field::HasMany,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    allocations
    avatar
    contributions
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    allocations
    avatar
    contributions
    end_period
    evaluations
    name
    offices
    projects
    punches
    questionnaires
    regional_holidays
    repositories
    skills
    users
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    allocations
    avatar
    contributions
    end_period
    evaluations
    name
    offices
    projects
    punches
    questionnaires
    regional_holidays
    repositories
    skills
    users
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

  # Overwrite this method to customize how companies are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(company)
  #   "Company ##{company.id}"
  # end
end
