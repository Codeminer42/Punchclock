module NewAdmin
  class UsersQuery
    def initialize(filters)
      self.filters = filters
    end

    def self.call(*args)
      new(*args).call
    end

    def call
      users = User.order(name: :asc)
                  .by_name_like(filters[:name])
                  .by_email_like(filters[:email])
                  .by_backend_level(filters[:backend_level])
                  .by_frontend_level(filters[:frontend_level])
                  .by_office(filters[:office_id])
                  .by_contract_type(filters[:contract_type])
                  .by_active(filters[:active])

      users = filtered_by_allocated(users)
      users = filtered_by_skills(users)
      users = users.admin if filters[:is_admin]
      users = users.office_heads if filters[:is_office_head]

      users
    end

    private

    attr_accessor :filters

    def filtered_by_skills(users)
      return users unless filters[:skill_ids]

      skill_ids = filters[:skill_ids].compact_blank

      skill_ids.present? ? users.by_skills_in(*skill_ids) : users
    end

    def filtered_by_allocated(users)
      return users if filters[:is_allocated].blank?

      filters[:is_allocated] == "true" ? users.allocated : users.not_allocated
    end
  end
end
